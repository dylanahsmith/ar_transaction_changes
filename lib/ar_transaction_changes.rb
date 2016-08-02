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

  private

  def write_attribute(attr_name, value) # override
    unless transaction_changed_attributes.key?(attr_name)
      transaction_changed_attributes[attr_name] = attributes[attr_name]
    end
    super
  end
end
