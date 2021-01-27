# ArTransactionChanges
[![Build Status](https://github.com/dylanahsmith/ar_transaction_changes/workflows/CI/badge.svg?branch=main)](https://github.com/dylanahsmith/ar_transaction_changes/actions?query=branch%3Amain)

Store all attribute changes for active record objects during a
transaction so that they are available in an after_commit callbacks.

Note that using previous_changes in an after_commit hook will only
return the attribute changes from the last time the record was
saved, which won't include all the changes made to the record in
the transaction if the record was saved multiple times in the same
transaction. Use this gem to solve this problem.

## Installation

Add this line to your application's Gemfile:

    gem 'ar_transaction_changes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar_transaction_changes

## Usage

Just include ArTransactionChanges and transaction_changed_attributes
will store the original values for all the changed attributes
throughout the transaction.

```ruby
class User < ActiveRecord::Base
  include ArTransactionChanges

  after_commit :print_transaction_changes

  def print_transaction_changes
    transaction_changed_attributes.each do |name, old_value|
      puts "attribute #{name}: #{old_value.inspect} -> #{send(name).inspect}"
    end
  end
end
```

## Important Notes

`ar_transaction_changes` may have conflict with another gems who modify
`active_record#write_attribute` method, e.g. `globalize` gem

the workaround is by requiring this gem first, for example:

```ruby
gem 'ar_transaction_changes', require: false
gem 'globalize', require: ['ar_transaction_changes', 'globalize']

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
