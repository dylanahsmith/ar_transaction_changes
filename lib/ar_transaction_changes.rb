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

  method_name = if ActiveRecord.gem_version >= Gem::Version.new("5.2.0.beta1")
    "_write_attribute"
  else
    "write_attribute"
  end

  define_method(method_name) do |attr_name, value, *options|
    attr_name = attr_name.to_s
    old_value = read_attribute(attr_name)
    ret = super(attr_name, value, *options)
    unless transaction_changed_attributes.key?(attr_name) || value == old_value
      transaction_changed_attributes[attr_name] = old_value
    end
    ret
  end
end
