require 'singleton'

require_relative 'fixture_finder'
require_relative 'fixture_loader'

class Kibutsu::FixtureWorld
  include Singleton

  def load_fixtures(fixtures_path)
    @fixture_tables = []
    Kibutsu::FixtureFinder.new(fixtures_path).fixture_file_paths.each do |fixture_file_path|
      @fixture_tables += Kibutsu::FixtureLoader.new(fixture_file_path).fixture_tables
    end
  end

  def fixtures
    @fixture_tables.flat_map(&:fixtures)
  end

  def fixture(name)
    fixtures.select{ |fixture| fixture.name == name }.first
  end

  attr_reader :fixture_tables

  private

  attr_reader :fixtures_path
end
