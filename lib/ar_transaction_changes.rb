require "ar_transaction_changes/version"

module ArTransactionChanges
  def create(*)
    super.tap do |status|
      store_transaction_changed_attributes if status != false
    end
  end

  def update(*)
    super.tap do |status|
      store_transaction_changed_attributes if status != false
    end
  end

  def committed!(*)
    super
  ensure
    @transaction_changed_attributes = nil
  end

  def rolledback!(*)
    super
  ensure
    @transaction_changed_attributes = nil
  end

  def transaction_changed_attributes
    changed_attributes.merge(@transaction_changed_attributes || {})
  end

  private

  def store_transaction_changed_attributes
    @transaction_changed_attributes = transaction_changed_attributes
  end
end
