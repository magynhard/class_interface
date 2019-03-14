# Ruby gem class_interface

Extends Ruby to support class interfaces.

That can be very handy in teams to declare requirements for specific types of classes.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'class_interface'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install class_interface
    
## Examples

### Defining an interface

It is a good idea, to start an interface name by convention with an I, following by a capitalized camel case constant name, i.e.: `IMyInterface, IHouse, IClassName, ...` 

```ruby
class IExample
  MIN_AGE = Integer
  DEFAULT_ENV = String
  SOME_CONSTANT = nil

  def self.some_static_method
  end

  def some_instance_method
  end
end
```

### Implementing an interface

```ruby
class MyImplementation
  MIN_AGE = 21
  DEFAULT_ENV = 'dev' 
  SOME_CONSTANT = 'some_value'
  
  def specific_method
    puts "very specific"
  end
  
  def self.some_static_method
    puts "static method is implemented!"
  end
  
  def some_instance_method
    # implementation
  end
  
  def self.another_methods
    # implementation
  end
  
  implements IExample
end
```

## Documentation
```ruby
#implements(InterfaceClassConstant)
```

_InterfaceClassConstant_ must be a valid InterfaceClassConstant or a String, containing a valid InterfaceClassConstant, i.e.: IMyInterface / "IMyInterface"

### Methods

All defined methods in the interface class must be implemented in the implementing class.
The parameter count must be the same.

### Constant Types

All CONSTANTS defined in the interface class must be implemented in the implementing class.
CONSTANTS of interfaces may be defined = nil, to allow all types of definitions in the implementing class.

To specify a type, assign its class constant, e.g. String, Array, ...
If a specified type is defined, it is mandatory for the implementation to use that type.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/magynhard/class_interface. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

