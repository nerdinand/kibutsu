require 'date'

class Kibutsu::Fixture
  TIMESTAMP_COLUMN_NAMES = %w[created_at updated_at].freeze

  def initialize(table, name, attributes)
    @table = table
    @name = name
    @attributes = attributes
  end

  def enriched_attributes(foreign_key_list, column_names)
    enriched_attributes = enrich_with_id(attributes)
    enriched_attributes = enrich_with_foreign_keys(enriched_attributes, foreign_key_list)
    enrich_with_timestamps(enriched_attributes, column_names)
  end

  attr_reader :table, :name, :attributes

  private

  def enrich_with_id(attr)
    attr.merge('id' => to_id(@name))
  end

  def enrich_with_foreign_keys(attr, foreign_key_list)
    table_references_in_attributes(foreign_key_list).each do |reference|
      referred_fixture_name = attr[reference.to_s]
      attr[reference.to_s] = to_id(referred_fixture_name)
      attr.delete(column_name_to_model_name(reference))
    end
    attr
  end

  def enrich_with_timestamps(attr, column_names)
    date_time = DateTime.now
    TIMESTAMP_COLUMN_NAMES.each do |timestamp_column_name|
      next unless column_names.include? timestamp_column_name.to_sym
      attr[timestamp_column_name] = date_time
    end
    attr
  end

  def table_references_in_attributes(foreign_key_list)
    table_references_in_attributes = []
    foreign_key_list.each do |foreign_key_information|
      raise if foreign_key_information[:columns].size != 1
      column_name = foreign_key_information[:columns].first
      table_references_in_attributes << foreign_key_information[:columns].first if @attributes.key?(column_name_to_model_name(column_name))
    end
    table_references_in_attributes
  end

  def column_name_to_model_name(column_name)
    column_name.to_s[0..-4]
  end

  def to_id(string)
    string.hash
  end
end
