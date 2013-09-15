# ArTransactionChanges
[![Build Status](https://travis-ci.org/dylanahsmith/ar_transaction_changes.png?branch=master)](https://travis-ci.org/dylanahsmith/ar_transaction_changes)

Store transaction changes for active record objects so that they
are available in an after_commit callbacks.

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
