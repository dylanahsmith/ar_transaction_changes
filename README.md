# ArTransactionChanges
[![Build Status](https://travis-ci.org/dylanahsmith/ar_transaction_changes.png?branch=master)](https://travis-ci.org/dylanahsmith/ar_transaction_changes)

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
