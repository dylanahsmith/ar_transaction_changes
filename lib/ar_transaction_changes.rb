require "ar_transaction_changes/version"

module ArTransactionChanges
  def run_callbacks(kind, &block)
    ret = super
    case kind.to_sym
    when :create, :update
      store_transaction_changed_attributes if ret != false
    when :commit, :rollback
      @transaction_changed_attributes = nil
    end

    ret
  end

  def transaction_changed_attributes
    changed_attributes.merge(@transaction_changed_attributes || {})
  end

  private

  def store_transaction_changed_attributes
    @transaction_changed_attributes = transaction_changed_attributes
  end
end
