class User < ActiveRecord::Base
  include ArTransactionChanges

  class ConnectionDetails
    attr_accessor :client_ip

    def initialize(client_ip:)
      @client_ip = client_ip
    end
  end

  serialize :connection_details, Array
  serialize :favourite_foods, Array
  serialize :favourite_cities_by_country, Hash

  attr_accessor :stored_transaction_changes

  before_save :sort_favourite_foods
  after_commit :store_transaction_changes_for_tests

  def sort_favourite_foods
    self.favourite_foods = favourite_foods.sort if favourite_foods_changed?
  end

  def store_transaction_changes_for_tests
    @stored_transaction_changes = transaction_changed_attributes.reduce({}) do |changes, (attr_name, value)|
      changes[attr_name] = [value, send(attr_name)]
      changes
    end
  end
end
