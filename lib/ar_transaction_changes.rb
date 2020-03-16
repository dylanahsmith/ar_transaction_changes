require "ar_transaction_changes/version"
require "active_record"

module ArTransactionChanges
  extend ActiveSupport::Concern

  included do
    before_commit do
      @_saved_start_transaction_state = @_start_transaction_state
    end
  end

  def _run_commit_callbacks
    super
  ensure
    @_saved_start_transaction_state = nil
  end

  def transaction_changed_attributes
    changed_attributes = HashWithIndifferentAccess.new
    if start_transaction_state = @_saved_start_transaction_state || @_start_transaction_state
      old_attributes = start_transaction_state.fetch(:attributes)
      self.class.attribute_types.each_key do |attr_name|
        original_value = old_attributes[attr_name].original_value
        new_value = attribute_in_database(attr_name)
        if original_value != new_value
          changed_attributes[attr_name] = original_value
        end
      end
    end
    changed_attributes
  end
end
