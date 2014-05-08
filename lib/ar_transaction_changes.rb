require "ar_transaction_changes/version"

module ArTransactionChanges
  # rails 4.0.0: renamed create/update to create_record/update_record
  # rails 4.0.6/4.1.2: prefixed create_record/update_record with an underscore
  create_or_update_method_format = ["_%s_record", "%s_record", "%s"].detect do |format|
    ["create", "update"].all? do |action|
      method_name = format % action
      ActiveRecord::Persistence.private_method_defined?(method_name.to_sym)
    end
  end or raise "Failed to find create/update record methods to monkey patch"
  create_method_name = (create_or_update_method_format % "create").to_sym
  update_method_name = (create_or_update_method_format % "update").to_sym

  define_method(create_method_name) do |*args|
    super(*args).tap do |status|
      store_transaction_changed_attributes if status != false
    end
  end

  define_method(update_method_name) do |*args|
    super(*args).tap do |status|
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
