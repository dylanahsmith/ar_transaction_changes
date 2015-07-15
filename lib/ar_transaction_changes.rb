require "ar_transaction_changes/version"

module ArTransactionChanges
  if Class.new { include ActiveSupport::Callbacks }.private_method_defined?(:_run_callbacks)
    def _run_create_callbacks
      ret = super
      store_transaction_changed_attributes if ret != false
      ret
    end

    def _run_update_callbacks
      ret = super
      store_transaction_changed_attributes if ret != false
      ret
    end

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
  else
    def run_callbacks(kind, *args)
      ret = super
      case kind.to_sym
      when :create, :update
        store_transaction_changed_attributes if ret != false
      when :commit, :rollback
        @transaction_changed_attributes = nil
      end

      ret
    end
  end

  def transaction_changed_attributes
    changed_attributes.merge(@transaction_changed_attributes || {})
  end

  private

  def store_transaction_changed_attributes
    @transaction_changed_attributes = transaction_changed_attributes
  end
end
