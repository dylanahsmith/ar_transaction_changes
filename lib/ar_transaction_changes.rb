require "ar_transaction_changes/version"

module ArTransactionChanges
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
    @transaction_changed_attributes ||= HashWithIndifferentAccess.new
  end

  def write_attribute(attr_name, value) # override
    attr_name = attr_name.to_s
    old_value = attributes[attr_name]
    ret = super
    unless transaction_changed_attributes.key?(attr_name) || value == old_value
      transaction_changed_attributes[attr_name] = old_value
    end
    ret
  end
end
