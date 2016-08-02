require "ar_transaction_changes/version"
require 'attributes_changed_by_write'

module ArTransactionChanges
  include AttributeChangedByWrite

  def _run_create_callbacks
    ret = super
    store_transaction_changed_attributes if ret != false
    ret
  end

  def _run_update_callbacks
    ret = super
    store_transaction_changed_attributes if ret != false
    ret
  end

  def _run_commit_callbacks
    super
  ensure
    @transaction_changed_attributes = nil
  end

  def _run_rollback_callbacks
    super
  ensure
    @transaction_changed_attributes = nil
  end

  def transaction_changed_attributes
    attributes_changed_by_setter.merge(attributes_changed_by_write.merge(@transaction_changed_attributes ||= {}))
  end

  private

  def store_transaction_changed_attributes
    @transaction_changed_attributes = transaction_changed_attributes
  end
end
