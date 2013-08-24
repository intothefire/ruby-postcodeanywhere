# ruby-postcodeanywhere

Ruby gem exposing the functionality of PostcodeAnywhere web services (specifically PAF related service)

## Usage

#### Bank Account Validation

```ruby
pa = PostcodeAnywhere::BankAccountValidation.new("ABC1-ABC1-ABC1-ABC1")  => #<PostcodeAnywhere::BankAccountValidation:0x007fad66d7e5b8>

pa.validate("12-12-12", "123123")  => #<PostcodeAnywhere::BankAccountResult:0x007fad6689c1d0 @is_correct=true, @is_direct_debit_capable=true...>
```


## Contributing to ruby-postcodeanywhere
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Chris Norman. See LICENSE.txt for further details.