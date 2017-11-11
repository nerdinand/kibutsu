require 'sequel'

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
      column :page_count, Integer

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end

  after do
    FileUtils.rm_f db_file_path
  end

  it 'loads fixtures' do
    Kibutsu.load_fixtures!(database_connection_url, fixtures_path)

    connection = Sequel.connect(database_connection_url)

    expect(connection[:authors].count).to eq(1)
    authors = connection[:authors].to_a
    expect(authors[0][:first_name]).to eq('Douglas')
    expect(authors[0][:last_name]).to eq('Adams')
    expect(authors[0][:created_at]).to be_a(Time)
    expect(authors[0][:updated_at]).to be_a(Time)

    expect(connection[:books].count).to eq(2)
    books = connection[:books].order(:created_at).to_a
    expect(books[0][:title]).to eq("The Hitchhiker's Guide to the Galaxy")
    expect(books[0][:author_id]).to eq(authors[0][:id])
    expect(books[0][:page_count]).to eq(179)
    expect(books[1][:title]).to eq('The Restaurant at the End of the Universe')
    expect(books[1][:author_id]).to eq(authors[0][:id])
    expect(books[1][:page_count]).to eq(200)
  end
end
