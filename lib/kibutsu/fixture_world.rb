require 'singleton'

require_relative 'fixture_finder'
require_relative 'fixture_loader'
require_relative 'database_connection'

module Kibutsu
  # Singleton class that holds all the information about fixtures and fixture
  # tables. This class really ties whole the gem together.
  class FixtureWorld
    include Singleton

    def load(database_connection_url, fixtures_path)
      @database_connection = Kibutsu::DatabaseConnection.new(
        database_connection_url
      )

      load_fixtures(fixtures_path)
      database_connection.insert_fixture_tables(tables_without_dependencies)
    end

    def load_fixtures(fixtures_path)
      initialize_empty_fixture_tables
      fill_fixture_table_information

      fixture_file_paths = FixtureFinder.new(fixtures_path).fixture_file_paths
      fixture_file_paths.each do |fixture_file_path|
        FixtureLoader.new(
          fixture_file_path, database_connection
        ).load_fixture_tables
      end
    end

    def find_table(table_name)
      @fixture_tables.find { |table| table.name == table_name }
    end

    attr_reader :fixture_tables

    private

    attr_reader :fixtures_path, :database_connection

    def initialize_empty_fixture_tables
      @fixture_tables = database_connection.table_names.map do |table_name|
        FixtureTable.new(table_name.to_s)
      end
    end

    def fill_fixture_table_information
      @fixture_tables.each do |fixture_table|
        fixture_table.column_names =
          database_connection.column_names(fixture_table.name)
        fixture_table.foreign_key_columns =
          database_connection.foreign_key_columns(fixture_table.name)
      end
    end

    def tables_without_dependencies
      @fixture_tables.select { |table| table.foreign_key_target_tables.none? }
    end
  end
end
