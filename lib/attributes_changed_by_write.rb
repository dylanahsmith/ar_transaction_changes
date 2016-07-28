module ArTransactionChanges
  module AttributeChangedByWrite
    def attributes_changed_by_write
      @attributes_changed_by_write ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    private

    def store_to_attributes_changed_by_write(attr_name)
      @attributes_changed_by_write = {attr_name.to_s => attributes[attr_name]}.merge(attributes_changed_by_write)
    end

    def changes_applied
      @attributes_changed_by_write = ActiveSupport::HashWithIndifferentAccess.new
      super
    end

    def clear_changes_information
      @attributes_changed_by_write = ActiveSupport::HashWithIndifferentAccess.new
      super
    end

    def write_attribute(attr_name, value)
      store_to_attributes_changed_by_write(attr_name) if attributes[attr_name] != value
      super
    end
  end
end
