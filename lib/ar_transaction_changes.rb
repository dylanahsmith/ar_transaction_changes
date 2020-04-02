require "ar_transaction_changes/version"
require "active_record"

module ArTransactionChanges
  def _run_commit_callbacks
    @in_after_commit_hook = true
    super
  ensure
    @transaction_changed_attributes = nil
    @in_after_commit_hook = false
  end

  def _run_rollback_callbacks
    super
  ensure
    @transaction_changed_attributes = nil
  end

  def transaction_changed_attributes
    unless @in_after_commit_hook
      raise "transaction_changed_attributes can only be used in an after_commit callback"
    end
    @transaction_changed_attributes
  end

  def _write_attribute(attr_name, value)
    tx_changes = @transaction_changed_attributes ||= HashWithIndifferentAccess.new

    attr_name = attr_name.to_s
    old_value = read_attribute(attr_name)
    ret = super(attr_name, value)
    new_value = read_attribute(attr_name)
    unless tx_changes.key?(attr_name) || new_value == old_value
      tx_changes[attr_name] = old_value
    end
    ret
  end
end
