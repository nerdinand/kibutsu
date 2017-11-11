RSpec.describe Kibutsu::FixtureFinder do
  subject { described_class.new('spec/fixtures/') }

  describe '#find_fixtures' do
    it 'finds fixture files ending in .yml or .yml.erb' do
      expect(subject.fixture_file_paths).to eq(
        ['spec/fixtures/books.yml', 'spec/fixtures/authors.yml.erb']
      )
    end
  end
end
