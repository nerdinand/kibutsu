RSpec.describe Kibutsu do
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

  it 'loads fixtures' do
    Kibutsu.load_fixtures!(database_connection_url, fixtures_path)
  end
end
