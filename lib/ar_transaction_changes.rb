require "ar_transaction_changes/version"
require "active_record"

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

  def _write_attribute(attr_name, value)
    attr_name = attr_name.to_s
    old_value = read_attribute(attr_name)
    ret = super(attr_name, value)
    new_value = read_attribute(attr_name)
    unless transaction_changed_attributes.key?(attr_name) || new_value == old_value
      transaction_changed_attributes[attr_name] = old_value
    end
    ret
  end
end
