require 'pathname'
require 'yaml'
require 'ar_transaction_changes'
require 'minitest/autorun'

ENV["RAILS_ENV"] = "test"

test_dir = Pathname.new(File.dirname(__FILE__))
config_filename = test_dir.join("database.yml").exist? ? "database.yml" : "database.yml.default"
database_yml = YAML.load(test_dir.join(config_filename).read)
database_config = database_yml.fetch("test")

if database_config.fetch('adapter') != 'sqlite3'
  ActiveRecord::Base.establish_connection(database_config.except("database"))
  ActiveRecord::Base.connection.recreate_database(database_config.fetch("database"))
end
ActiveRecord::Base.establish_connection(database_config)

ActiveRecord::Base.connection.tap do |db|
  db.create_table(:users) do |t|
    t.string :name
    t.string :occupation
    t.integer :age
    t.text :connection_details
    t.text :notes
    t.timestamps null: false
  end
end

Dir[test_dir.join("models/*.rb")].each{ |file| require file }
