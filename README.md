# DbMonit

DbMonit is a simple gem to help you monitor the usage of a given database instance (so far only works for MySQL, but that will change soon).

Once you install it, you can plug in your existing analytics or use it as a standalone information tool.

## Requirements

* MySQL: Specifically any version of MySQL that has enabled the `performance_schema` engine.
* Ruby: it is tested with ruby 2.4, but it should work just fine in any ruby 2.X version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_monit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install db_monit

## Usage

### Command arguments

db_monit command requires a conf file (can be overridden with input parameters) to connect to a given MySQL instance.

A simple example referring a conf file:

```
db_monit mysql status --conf=/path/to/db.conf
```

Once the above command gets executed it should connect to a MySQL instance and return a list of the variables available in the performance_schema with their values.

You can also specify configuration parameters directly in the command line and they would take precedence over the data (if present) in the conf file.

```
db_monit mysql status --host='localhost' --username='username' --password='password'
```

### Available commands

**status**: Shows the status of the instance. For MySQL is going to print the variables names and values from the `performance_schema` engine.

**threads**: Shows information for each of the threads running in the server.

**watch**: Waits for a given trigger to occur and collects diagnostics information. A trigger can be either a function or a directly specified variable.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renehernandez/db_monit.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

