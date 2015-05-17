# Console

Simple console

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'console', github: 'xjz19901211/console'
```

And then execute:

    $ bundle


## Usage

See examples/demo.rb

```
# my_console.rb
class MyConsole
  include Console

  define_cmd(:rand, "puts random number") do |max = 100|
    puts rand(max.to_i)
  end
end

MyConsole.new.start("my-console > ", "Use 'help' show all commands")
```

```
$ ruby my_console.rb
Use 'help' show all commands
my-console > help
  help: show all commands
  exit: exit console
  rand: puts random number
my-console > rand
23
my-console > rand 10
4
my-console > rand 10100
2492
my-console > exit
$ 

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/console/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
