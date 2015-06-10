ENV["RAILS_ENV"] = "test"
require 'pathname'
require 'yaml'
require 'active_record'
require 'ar_transaction_changes'
require 'minitest/autorun'

MiniTest::Test = MiniTest::Unit::TestCase unless defined?(MiniTest::Test)

test_dir = Pathname.new(File.dirname(__FILE__))
config_filename = test_dir.join("database.yml").exist? ? "database.yml" : "database.yml.default"
database_yml = YAML.load(test_dir.join(config_filename).read)
ActiveRecord::Base.establish_connection database_yml['test']

if ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR >= 2
  ActiveRecord::Base.raise_in_transactional_callbacks = true
end

ActiveRecord::Base.connection.tap do |db|
  db.drop_table(:users) if db.table_exists?(:users)
  db.create_table(:users) do |t|
    t.string :name
    t.string :occupation
  end
end

Dir[test_dir.join("models/*.rb")].each{ |file| require file }
