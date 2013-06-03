require "ar_transaction_changes/version"

module ArTransactionChanges

  def self.included(clazz)
    clazz.after_save :store_transaction_changed_attributes
    clazz.after_commit :reset_changed_attributes
  end

  def transaction_changed_attributes
    changed_attributes.merge(@transaction_changed_attributes || {})
  end

  private

  def reset_changed_attributes
    @transaction_changed_attributes = nil
  end

  def store_transaction_changed_attributes
    @transaction_changed_attributes = transaction_changed_attributes
  end
end
