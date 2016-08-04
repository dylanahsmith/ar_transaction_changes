require "ar_transaction_changes/version"

module ArTransactionChanges
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
    @transaction_changed_attributes = nil
  end

  def _run_rollback_callbacks
    super
  ensure
    @deprecated_transaction_changed_attributes = nil
    @transaction_changed_attributes = nil
  end

  def deprecated_transaction_changed_attributes
    changed_attributes.merge(@deprecated_transaction_changed_attributes ||= {})
  end

  def transaction_changed_attributes
    @transaction_changed_attributes ||= HashWithIndifferentAccess.new
  end

  private

  def write_attribute(attr_name, value) # override
    unless transaction_changed_attributes.key?(attr_name) || attributes.with_indifferent_access[attr_name] == value
      transaction_changed_attributes[attr_name] = attributes.with_indifferent_access[attr_name]
    end
    super
  end

  def store_deprecated_transaction_changed_attributes
    @deprecated_transaction_changed_attributes = deprecated_transaction_changed_attributes
  end

end
