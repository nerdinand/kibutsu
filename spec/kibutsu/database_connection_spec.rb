require 'ostruct'

RSpec.describe Kibutsu::DatabaseConnection do
  let(:db_file_path) { 'spec/integration/db/db.sqlite3' }
  let(:database_connection_url) { "sqlite://#{db_file_path}" }
  let(:fixtures_path) { 'spec/fixtures/' }

  before do
    connection = Sequel.connect(database_connection_url)

    connection.create_table :authors do
      primary_key :id

      column :first_name, String
      column :last_name, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    connection.create_table :books do
      primary_key :id
      foreign_key :author_id, :authors, null: false

      column :title, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end

  after do
    FileUtils.rm_f db_file_path
  end

  subject { described_class.new(database_connection_url) }
  let(:table_name) { 'books' }

  describe '#foreign_key_column_names' do
    it 'returns information about the foreign keys of a table' do
      expect(subject.foreign_key_column_names(table_name)).to eq(
        [:author_id]
      )
    end
  end

  describe '#column_names' do
    it 'returns the column names of a table' do
      expect(subject.column_names(table_name)).to eq(
        %i[id author_id title created_at updated_at]
      )
    end
  end
end
