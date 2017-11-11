module Kibutsu
  class FixtureTable
    def initialize(table_name, column_names, foreign_key_column_names)
      @table_name = table_name
      @column_names = column_names
      @foreign_key_column_names = foreign_key_column_names
      @fixtures = []
    end

    def <<(fixture)
      @fixtures << fixture
    end

    attr_reader :table_name, :column_names, :foreign_key_column_names, :fixtures
  end
end
