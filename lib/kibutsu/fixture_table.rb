module Kibutsu
  class FixtureTable
    def initialize(name)
      @name = name
      @column_names = nil
      @foreign_key_columns = nil
      @foreign_key_source_tables = []
      @fixtures = []
    end

    def <<(fixture)
      @fixtures << fixture
    end

    def foreign_key_target_tables
      @foreign_key_columns.map(&:target_table)
    end

    def foreign_key_columns=(foreign_key_columns)
      @foreign_key_columns = foreign_key_columns

      foreign_key_columns.each do |column|
        column.target_table.foreign_key_source_tables << self
      end
    end

    attr_reader :name, :fixtures, :foreign_key_source_tables, :foreign_key_columns
    attr_accessor :column_names
  end
end
