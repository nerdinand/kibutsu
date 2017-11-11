require_relative 'kibutsu/kibutsu'
require_relative 'kibutsu/fixture_world'

module Kibutsu
  def self.load_fixtures!(database_connection_url, fixtures_path)
    fixture_world = FixtureWorld.instance
    fixture_world.load(database_connection_url, fixtures_path)
  end

  def self.fixture_name_to_id(fixture_name)
    fixture_name.hash
  end
end
