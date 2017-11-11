require 'sequel'

require_relative 'foreign_key_column'

module Kibutsu
  class DatabaseConnection
    def initialize(connection_string)
      @connection = Sequel.connect(connection_string)
    end

    def insert_fixture_tables(fixture_tables)
      fixture_tables.each do |fixture_table|
        insert_table(fixture_table)
        insert_fixture_tables(fixture_table.foreign_key_source_tables)
      end
    end

    def column_names(table_name)
      connection.schema(table_name.to_s).map(&:first)
    end

    def foreign_key_columns(table_name)
      connection.foreign_key_list(table_name.to_s).map do |foreign_key_info|
        ForeignKeyColumn.new(
          FixtureWorld.instance.find_table(table_name.to_s),
          foreign_key_info[:columns].first.to_s,
          FixtureWorld.instance.find_table(foreign_key_info[:table].to_s)
        )
      end
    end

    def table_names
      connection.tables
    end

    private

    attr_reader :connection

    def insert_table(fixture_table)
      fixture_table.fixtures.each do |fixture|
        insert_fixture(fixture)
      end
    end

    def insert_fixture(fixture)
      fixture_table = fixture.table
      attributes = fixture.enriched_attributes
      connection[fixture_table.name.to_sym].insert(attributes)
    end
  end
end
