require 'date'

class Kibutsu::Fixture
  TIMESTAMP_COLUMN_NAMES = %w[created_at updated_at].freeze

  def initialize(table, name, attributes)
    @table = table
    @name = name
    @attributes = attributes
  end

  def enriched_attributes
    enriched_attributes = enrich_with_id(attributes)
    enriched_attributes = enrich_with_foreign_keys(enriched_attributes)
    enrich_with_timestamps(enriched_attributes)
  end

  attr_reader :table, :name, :attributes

  private

  def enrich_with_id(attr)
    attr.merge('id' => Kibutsu.fixture_name_to_id(@name))
  end

  def enrich_with_foreign_keys(attr)
    table_references_in_attributes(table.foreign_key_column_names).each do |reference|
      referred_fixture_name = attr[reference.to_s]
      attr[reference.to_s] = Kibutsu.fixture_name_to_id(referred_fixture_name)
      attr.delete(column_name_to_model_name(reference))
    end
    attr
  end

  def enrich_with_timestamps(attr)
    date_time = DateTime.now
    TIMESTAMP_COLUMN_NAMES.each do |timestamp_column_name|
      next unless table.column_names.include? timestamp_column_name.to_sym
      attr[timestamp_column_name] = date_time
    end
    attr
  end

  def table_references_in_attributes(foreign_key_column_names)
    table_references_in_attributes = []
    foreign_key_column_names.each do |foreign_key_column_name|
      table_references_in_attributes << foreign_key_column_name if @attributes.key?(column_name_to_model_name(foreign_key_column_name))
    end
    table_references_in_attributes
  end

  def column_name_to_model_name(column_name)
    column_name.to_s[0..-4]
  end
end
