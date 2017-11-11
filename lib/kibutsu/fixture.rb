require 'date'

module Kibutsu
  # Corresponds to one named fixture from a fixture file.
  class Fixture
    TIMESTAMP_COLUMN_NAMES = %w[created_at updated_at].freeze

    def initialize(table, name, attributes)
      @table = table
      @name = name
      @attributes = attributes
    end

    def enriched_attributes
      enriched_attributes = enrich_with_id(attributes)
      enriched_attributes = enrich_with_foreign_keys(enriched_attributes)
      enrich_with_timestamps(enriched_attributes)
    end

    attr_reader :table, :name, :attributes

    private

    def enrich_with_id(attr)
      attr.merge('id' => Kibutsu.fixture_name_to_id(@name))
    end

    def enrich_with_foreign_keys(attr)
      foreign_key_columns.each do |foreign_key_column|
        foreign_fixture_name = foreign_table_reference(attr, foreign_key_column)
        if foreign_fixture_name
          attr[foreign_key_column.name] =
            Kibutsu.fixture_name_to_id(foreign_fixture_name)
        end
      end
      attr
    end

    def foreign_key_columns
      table.foreign_key_columns
    end

    def enrich_with_timestamps(attr)
      date_time = DateTime.now
      TIMESTAMP_COLUMN_NAMES.each do |timestamp_column_name|
        next unless table.column_names.include? timestamp_column_name.to_sym
        attr[timestamp_column_name] = date_time
      end
      attr
    end

    def foreign_table_reference(attr, foreign_key_column)
      attr.delete(column_name_to_model_name(foreign_key_column.name))
    end

    def column_name_to_model_name(column_name)
      column_name.to_s[0..-4]
    end
  end
end
