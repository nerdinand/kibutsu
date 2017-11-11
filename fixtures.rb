# frozen_string_literal: true

require 'yaml'
require 'tilt'
require 'erb'

fixtures_path = 'spec/fixtures'

@connection = Hanami::Model.configuration.connection
@fixture_landscape = {}
@execution_plan = {}

def foreign_key_columns(table_name)
  @connection[table_name.to_sym].columns.select do |column|
    column != :id && column.to_s.end_with?('id')
  end
end

def add_timestamps_if_necessary(attributes)
  %w[created_at updated_at].each do |timestamp_attribute|
    if attributes[timestamp_attribute].nil?
      attributes[timestamp_attribute] = DateTime.now
    end
  end

  attributes
end

def lookup_foreign_keys(table_name, attributes)
  foreign_key_columns = foreign_key_columns(table_name)

  foreign_key_columns.each do |foreign_key_column|
    foreign_record_name = attributes.delete(foreign_key_column.to_s[0..-4])
    next if foreign_record_name.nil?
    attributes[foreign_key_column.to_s] =
      Fixtures.record_name_to_id(foreign_record_name)
  end

  attributes
end

def add_id_column(record_name, attributes)
  attributes['id'] = Fixtures.record_name_to_id(record_name)
  attributes
end

def enrich_attributes(table_name, record_name, attributes)
  add_id_column(
    record_name,
    add_timestamps_if_necessary(
      lookup_foreign_keys(table_name, attributes)
    )
  )
end

def process_records(table_name, records)
  records.each do |record_name, attributes|
    @execution_plan[table_name] ||= []
    @execution_plan[table_name] << enrich_attributes(
      table_name, record_name, attributes
    )
  end
end

def process_fixture(fixture_path)
  fixture_hash = YAML.safe_load(Tilt::ERBTemplate.new(fixture_path).render)
  table_name = File.basename(fixture_path, '.*')
  @fixture_landscape[table_name] = fixture_hash
  process_records(table_name, fixture_hash)
end

def insert_records_for_table(table_name)
  @connection[table_name].delete
  return if @execution_plan[table_name.to_s].nil?

  @execution_plan[table_name.to_s].each do |attributes|
    # puts "INSERT #{table_name}: #{attributes}"
    @connection[table_name].insert(attributes)
  end
end

def insert_records(dependency_graph)
  dependency_graph.each do |table_name, dependencies|
    insert_records_for_table(table_name)
    insert_records(dependencies)
  end
end

def dependency_graph # rubocop:disable Metrics/MethodLength
  {
    users: {},
    run_imports: {},
    patients: {
      samples: {
        runs: {
          spots: {
            curves: {
              channel_traces: {}
            },
            afm_spot_qualities: {},
            histology_spot_qualities: {},
            macroscopic_spot_qualities: {}
          },
          devices: {
            afm_heads: {}
          },
          cantilevers: {}
        },
        histology_images: {},
        histology_sample_assessments: {
          histology_sample_assessment_diagnoses: {}
        }
      },
      pathology_diagnoses: {}
    }
  }
end

class Fixtures
  def self.record_name_to_id(record_name)
    record_name.to_s.hash
  end

  def self.dont_care(type)
    case type
    when :string
      "don't care about this string"
    when :number
      0
    when :bytea
      "binary value we don't care about"
    when :boolean
      false
    end
  end
end

@connection.transaction do
  Dir.glob(fixtures_path + '/**/*.yml').each do |fixture_path|
    process_fixture(fixture_path)
  end
  insert_records(dependency_graph)
end
