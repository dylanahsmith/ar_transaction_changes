module DeprecatedArTransactionChanges
  def _run_create_callbacks
    ret = super
    store_deprecated_transaction_changed_attributes if ret != false
    ret
  end

  def _run_update_callbacks
    ret = super
    store_deprecated_transaction_changed_attributes if ret != false
    ret
  end

  def _run_commit_callbacks
    super
  ensure
    @deprecated_transaction_changed_attributes = nil
  end

  def _run_rollback_callbacks
    super
  ensure
    @deprecated_transaction_changed_attributes = nil
  end

  def deprecated_transaction_changed_attributes
    changed_attributes.merge(@deprecated_transaction_changed_attributes ||= {})
  end

  private

  def store_deprecated_transaction_changed_attributes
    @deprecated_transaction_changed_attributes = deprecated_transaction_changed_attributes
  end
end
