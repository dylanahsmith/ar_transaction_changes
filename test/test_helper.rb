require 'pathname'
require 'yaml'
require 'ar_transaction_changes'
require 'minitest/autorun'

ENV["RAILS_ENV"] = "test"

test_dir = Pathname.new(File.dirname(__FILE__))
config_filename = test_dir.join("database.yml").exist? ? "database.yml" : "database.yml.default"
database_yml = YAML.load(test_dir.join(config_filename).read)
database_config = database_yml.fetch("test")

ActiveRecord::Base.establish_connection(database_config.except("database"))
ActiveRecord::Base.connection.recreate_database(database_config.fetch("database"))
ActiveRecord::Base.establish_connection(database_config)

ActiveRecord::Base.connection.tap do |db|
  db.create_table(:users) do |t|
    t.string :name
    t.string :occupation
    t.text :settings
    t.timestamps null: false
  end
end

Dir[test_dir.join("models/*.rb")].each{ |file| require file }
