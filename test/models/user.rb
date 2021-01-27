class User < ActiveRecord::Base
  include ArTransactionChanges

  class ConnectionDetails
    attr_accessor :client_ip

    def initialize(client_ip:)
      @client_ip = client_ip
    end
  end

  serialize :connection_details, Array
  serialize :notes, Array

  attr_accessor :stored_transaction_changes

  after_commit :store_transaction_changes_for_tests

  def store_transaction_changes_for_tests
    @stored_transaction_changes = transaction_changed_attributes.reduce({}) do |changes, (attr_name, value)|
      changes[attr_name] = [value, send(attr_name)]
      changes
    end
  end
end
