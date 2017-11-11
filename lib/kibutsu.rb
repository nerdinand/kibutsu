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
    fixture_name.to_s.hash
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
