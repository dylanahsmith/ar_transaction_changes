require "ar_transaction_changes/version"

module ArTransactionChanges
  create_or_update_method_format = if ActiveRecord::VERSION::MAJOR <= 3
    create_method_name = :create
    update_method_name = :update
  elsif ActiveRecord::Persistence.private_method_defined?(:create_record)
    create_method_name = :create_record
    update_method_name = :update_record
  else
    create_method_name = :_create_record
    update_method_name = :_update_record
  end

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
