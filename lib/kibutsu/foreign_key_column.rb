module Kibutsu
  # Corresponds to a foreign key column in the database.
  class ForeignKeyColumn
    def initialize(source_table, name, target_table)
      @source_table = source_table
      @name = name
      @target_table = target_table
    end

    attr_reader :source_table, :name, :target_table
  end
end
