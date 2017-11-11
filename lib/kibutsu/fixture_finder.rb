class Kibutsu::FixtureFinder
  def initialize(fixtures_path)
    @fixtures_path = fixtures_path
  end

  def fixture_file_paths
    Dir[File.join(fixtures_path, '**', '*.{yml,yml.erb}')]
  end

  private

  attr_reader :fixtures_path
end
