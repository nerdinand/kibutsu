RSpec.describe Kibutsu::FixtureFinder do
  subject { described_class.new('spec/fixtures/') }

  describe '#fixture_file_paths' do
    it 'finds fixture file paths ending in .yml or .yml.erb' do
      expect(subject.fixture_file_paths).to eq(
        ['spec/fixtures/authors.yml', 'spec/fixtures/books.yml.erb']
      )
    end
  end
end
