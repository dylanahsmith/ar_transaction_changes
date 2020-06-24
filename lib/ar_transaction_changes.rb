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
    old_value = _read_attribute_for_transaction(attr_name)
    ret = yield
    new_value = _read_attribute_for_transaction(attr_name)
    unless transaction_changed_attributes.key?(attr_name) || new_value == old_value
      attribute = @attributes[attr_name]
      transaction_changed_attributes[attr_name] = if attribute.type.is_a?(::ActiveRecord::Type::Serialized)
        attribute.type.deserialize(old_value)
      else
        old_value
      end
      transaction_changed_attributes
    end
    ret
  end

  def _read_attribute_for_transaction(attr_name)
    attribute = @attributes[attr_name]
    if attribute.type.is_a?(::ActiveRecord::Type::Serialized)
      if attribute.came_from_user?
        attribute.type.serialize(attribute.value_before_type_cast)
      else
        attribute.value_before_type_cast
      end
    else
      _read_attribute(attr_name)
    end
  end
end
