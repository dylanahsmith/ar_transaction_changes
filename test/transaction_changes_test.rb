require 'test_helper'

class TransactionChangesTest < MiniTest::Unit::TestCase
  def setup
    @user = User.new(:name => "Dylan", :occupation => "Developer")
    @user.save!
    @user.stored_transaction_changes = nil
  end

  def teardown
    User.delete_all
  end

  def test_transaction_changes_for_create
    user = User.new(:name => "Dylan")
    user.save!
    assert_equal [nil, "Dylan"], user.stored_transaction_changes["name"]
  end

  def test_transaction_changes_for_update
    @user.name = "Dillon"
    @user.save!
    assert_equal ["Dylan", "Dillon"], @user.stored_transaction_changes["name"]
  end

  def test_transaction_changes_for_double_save
    @user.transaction do
      @user.name = "Dillon"
      @user.save!

      @user.occupation = "Tester"
      @user.save!
    end
    assert_equal ["Dylan", "Dillon"], @user.stored_transaction_changes["name"]
    assert_equal ["Developer", "Tester"], @user.stored_transaction_changes["occupation"]
  end

  def test_transaction_changes_for_rollback
    @user.transaction do
      @user.name = "Dillon"
      @user.save!
      raise ActiveRecord::Rollback
    end
    assert_equal nil, @user.stored_transaction_changes
  end

  def test_transaction_changes_after_reload_saved
    @user.transaction do
      @user.name = "Dillon"
      @user.save!

      @user.reload
    end
    assert_equal ["Dylan", "Dillon"], @user.stored_transaction_changes["name"]
  end

  def test_transaction_changes_after_reload_unsaved
    @user.transaction do
      @user.name = "Dillon"
      @user.save!

      @user.name = "Andrew"
      assert_equal "Dylan", @user.transaction_changed_attributes["name"]
      @user.reload
    end
    assert_equal ["Dylan", "Dillon"], @user.stored_transaction_changes["name"]
  end

  def test_transaction_changes_for_changing_updated_at
    @user.update_attributes!(updated_at: Time.now - 1.second)
    old_updated_at = @user.updated_at
    @user.stored_transaction_changes = nil

    @user.updated_at = Time.now
    @user.save!

    assert_equal [old_updated_at, @user.updated_at], @user.stored_transaction_changes["updated_at"]
  end

  def test_transaction_changes_for_touch
    @user.update_attributes!(updated_at: Time.now - 1.second)
    old_updated_at = @user.updated_at
    @user.stored_transaction_changes = nil

    @user.touch

    assert_equal [old_updated_at, @user.updated_at], @user.stored_transaction_changes["updated_at"]
  end

  def test_transaction_changes_for_multiple_changes
    @user.name = "Dillon"
    @user.name = "Lisa"
    @user.save!
    assert_equal ["Dylan", "Lisa"], @user.stored_transaction_changes["name"]
  end
end
