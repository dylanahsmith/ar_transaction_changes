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
    _store_transaction_changed_attributes(attr_name) do
      super(attr_name, value)
    end
  end

  if ActiveRecord.version >= Gem::Version.new('6.1.0.alpha')
    def write_attribute(attr_name, value)
      _store_transaction_changed_attributes(attr_name) do
        super(attr_name, value)
      end
    end
  end

  private

  def _store_transaction_changed_attributes(attr_name)
    attr_name = attr_name.to_s
    old_value = read_attribute(attr_name)
    ret = yield
    new_value = read_attribute(attr_name)
    unless transaction_changed_attributes.key?(attr_name) || new_value == old_value
      transaction_changed_attributes[attr_name] = old_value
    end
    ret
  end
end
