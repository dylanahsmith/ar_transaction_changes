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

  def changes_applied
    ret = super
    changes = saved_changes.transform_values(&:first)
    transaction_changed_attributes.reverse_merge!(changes)
    ret
  end

  if ActiveRecord.version < Gem::Version.new('6.0')
    def touch(*names, **)
      attribute_names = timestamp_attributes_for_update_in_model
      attribute_names |= names.map(&:to_s)
      attribute_names.each do |attr_name|
        next if transaction_changed_attributes.key?(attr_name)
        transaction_changed_attributes[attr_name] = read_attribute(attr_name)
      end
      super
    end
  end
end
