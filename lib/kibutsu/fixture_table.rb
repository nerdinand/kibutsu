module Kibutsu
  class FixtureTable
    def initialize(name, column_names, foreign_key_columns)
      @name = name
      @column_names = column_names
      @foreign_key_columns = foreign_key_columns
      @fixtures = []
    end

    def <<(fixture)
      @fixtures << fixture
    end

    def dependent_tables

    end

    attr_reader :name, :column_names, :foreign_key_columns, :fixtures
  end
end
