require 'xxhash'

require_relative 'kibutsu/fixture_world'

#
# Main module containing the public API of Kibutsu
#
module Kibutsu
  def self.load_fixtures!(database_connection_url, fixtures_path)
    fixture_world = FixtureWorld.instance
    fixture_world.load(database_connection_url, fixtures_path)
  end

  def self.fixture_name_to_id(fixture_name)
    # hash algorithm based on djb2 (see http://www.cse.yorku.ca/~oz/hash.html)
    # scaled to signed int range for postgres int compatibility
    hash = 5381
    fixture_name.to_s.each_char { |c| hash = ((hash << 5) + hash) + c.ord }
    (hash % 4294967295) - 2147483648
  end

  def self.dont_care(type)
    case type
    when :string
      "don't care about this string"
    when :number
      0
    when :boolean
      false
    end
  end
end
