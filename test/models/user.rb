class User < ActiveRecord::Base
  include ArTransactionChanges

  store :settings, accessors: :favorite_color

  attr_accessor :stored_transaction_changes

  after_commit :store_transaction_changes_for_tests

  def store_transaction_changes_for_tests
    @stored_transaction_changes = transaction_changed_attributes.reduce({}) do |changes, (attr_name, value)|
      changes[attr_name] = [value, send(attr_name)]
      changes
    end
  end
end
