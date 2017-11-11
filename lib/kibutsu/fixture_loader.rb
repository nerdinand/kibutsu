require 'yaml'
require 'erb'

require_relative 'fixture_table'
require_relative 'fixture'

class Kibutsu::FixtureLoader
  def initialize(fixture_file_path)
    @fixture_file_path = fixture_file_path
  end

  def fixture_tables
    file_content = File.read(fixture_file_path)
    yaml_content = if fixture_file_path.end_with? '.yml.erb'
      run_erb(file_content)
    else
      file_content
    end
    fixtures_hash = load_fixture(yaml_content)
    fixtures_hash.map do |table_name, fixtures|
      table = Kibutsu::FixtureTable.new(table_name)
      fixtures.each do |fixture_name, attributes|
        table << Kibutsu::Fixture.new(table, fixture_name, attributes)
      end
      table
    end
  end

  private

  attr_reader :fixture_file_path

  def run_erb(file_content)
    ERB.new(file_content).result(binding)
  end

  def load_fixture(yaml_content)
    YAML.safe_load(yaml_content)
  end
end
