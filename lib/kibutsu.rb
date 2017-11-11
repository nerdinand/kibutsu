require_relative 'kibutsu/kibutsu'
require_relative 'kibutsu/fixture_world'
require_relative 'kibutsu/database_connection'

module Kibutsu
  def self.load_fixtures!(database_connection_url, fixtures_path)
    fixture_world = FixtureWorld.instance
    fixture_world.load_fixtures(fixtures_path)

    DatabaseConnection.new(database_connection_url).insert_fixture_tables(
      fixture_world.fixture_tables
    )
  end
end
