require 'sequel'

module Kibutsu
  class DatabaseConnection
    def initialize(connection_string)
      @connection = Sequel.connect(connection_string)
    end

    def insert_fixture_tables(fixture_tables)
      fixture_tables.each do |fixture_table|
        insert_table(fixture_table)
      end
    end

    def column_names(table_name)
      connection.schema(table_name.to_s).map(&:first)
    end

    def foreign_key_column_names(table_name)
      connection.foreign_key_list(table_name.to_s).map do |foreign_key_info|
        foreign_key_info[:columns].first
      end
    end

    private

    attr_reader :connection

    def insert_table(fixture_table)
      fixture_table.fixtures.each do |fixture|
        insert_fixture(fixture)
      end
    end

    def insert_fixture(fixture)
      p fixture
      fixture_table = fixture.table
      attributes = fixture.enriched_attributes
      connection[fixture_table.table_name.to_sym].insert(attributes)
    end
  end
end
