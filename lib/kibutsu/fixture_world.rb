require 'singleton'

require_relative 'fixture_finder'
require_relative 'fixture_loader'
require_relative 'database_connection'

module Kibutsu
  class FixtureWorld
    include Singleton

    def load(database_connection_url, fixtures_path)
      @database_connection = Kibutsu::DatabaseConnection.new(
        database_connection_url
      )

      load_fixtures(fixtures_path)
      database_connection.insert_fixture_tables(fixture_tables)
    end

    def load_fixtures(fixtures_path)
      @fixture_tables = []
      fixture_file_paths = FixtureFinder.new(fixtures_path).fixture_file_paths
      fixture_file_paths.each do |fixture_file_path|
        @fixture_tables +=
          FixtureLoader.new(
            fixture_file_path,
            database_connection
          ).fixture_tables
      end
    end

    attr_reader :fixture_tables

    private

    attr_reader :fixtures_path, :database_connection
  end
end
