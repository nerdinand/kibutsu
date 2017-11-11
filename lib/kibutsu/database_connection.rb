require 'sequel'

class Kibutsu::DatabaseConnection
  def initialize(connection_string)
    @connection = Sequel.connect(connection_string)
  end

  def insert_fixture_tables(fixture_tables)
    fixture_tables.each do |fixture_table|
      insert_table(fixture_table)
    end
  end

  def foreign_key_list(fixture_table)
    connection.foreign_key_list(fixture_table.table_name)
  end

  def column_names(fixture_table)
    connection.schema(fixture_table.table_name).map(&:first)
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

    attributes = fixture.enriched_attributes(
      foreign_key_list(fixture_table),
      column_names(fixture_table)
    )
    connection[fixture_table.table_name.to_sym].insert(attributes)
  end
end
