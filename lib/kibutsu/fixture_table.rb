class Kibutsu::FixtureTable
  def initialize(table_name)
    @table_name = table_name
    @fixtures = []
  end

  def <<(fixture)
    @fixtures << fixture
  end

  attr_reader :table_name, :fixtures
end
