module Kibutsu
  class ForeignKeyColumn
    def initialize(name, referencing_table)
      @name = name
      @referencing_table = referencing_table
    end

    attr_reader :name, :referencing_table
  end
end
