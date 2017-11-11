require 'yaml'
require 'erb'

require_relative 'fixture_table'
require_relative 'fixture'

module Kibutsu
  # Loads fixtures from files, optionally with ERB pre-processing and creates
  # Fixture objects from them.
  class FixtureLoader
    def initialize(fixture_file_path, database_connection)
      @fixture_file_path = fixture_file_path
      @database_connection = database_connection
    end

    def load_fixture_tables
      file_content = File.read(fixture_file_path)
      yaml_content = if fixture_file_path.end_with? '.yml.erb'
                       run_erb(file_content)
                     else
                       file_content
                     end
      fixtures_hash = load_fixture(yaml_content)
      build_fixture_tables(fixtures_hash)
    end

    private

    attr_reader :fixture_file_path, :database_connection

    def build_fixture_tables(fixtures_hash)
      fixtures_hash.map do |table_name, fixtures|
        table = Kibutsu::FixtureWorld.instance.find_table(table_name)

        raise "Couldn't find table with name #{table_name}" if table.nil?

        fixtures.each do |fixture_name, attributes|
          table << Kibutsu::Fixture.new(table, fixture_name, attributes)
        end
        table
      end
    end

    def run_erb(file_content)
      ERB.new(file_content).result(binding)
    end

    def load_fixture(yaml_content)
      YAML.safe_load(yaml_content)
    end
  end
end
