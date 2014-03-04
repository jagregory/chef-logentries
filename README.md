# chef-logentries

## Description

Installs the [Logentries](http://logentries.com) [Agent](http://logentries.com/doc/agent/), and provides definitions to manage registering servers and following logs.

## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error:

* Ubuntu
* Amazon Linux

## Recipes

* `logentries` - Set up the apt repository and install the logentries package

## Usage

This cookbook installs the Logentries Agent package from the Logentries apt repository.

Additionally this cookbook provides a `logentries` definition which you can use to register hosts, follow logs, and execute other `le` based commands.

```ruby
# register a server
logentries do
  account_key 'abcdefgh-ijkl-mnop-qrst-uvwxyz123456'
  server_name 'appserver'

  action :register
end

# follow a log (if it hasn't already been logged)
logentries '/var/log/syslog' do
  log_name 'Syslog'
  action :follow
end
```

You can use logentries from a json node config too by specifying a logentries element in your config with an `account_key`, `server_name`, and optionally some `log_files`.

```json
{
  "logentries": {
    "account_key": "abcdefgh-ijkl-mnop-qrst-uvwxyz123456",
    "server_name": "My Server",
    "log_files": {
      "App Server": "/var/www/myapp/log/production.log",
      "Syslog": "/var/log/syslog"
    }
  }
}
```

## Notes

Logentries is split into two packages, `logentries` and `logentries-daemon`, the former contains the command-line tools and the latter is the reporting agent. Unfortunately, when you install the `logentries-daemon` package it immediately tries to start the agent and will fail if you haven't pre-configured your host settings; this is problematic in a Chef script, because we haven't had an opportunity to set things up yet.

To solve this problem, the commandline tools are installed immediately, then the `logentries-daemon` package will only be installed at the end of your chef run; it will be triggered by the use of any of the `logentries` definitions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

**chef-logentries**

* Freely distributable and licensed under the MIT license.
* Copyright (c) 2012 James Gregory (james@jagregory.com)
* http://www.jagregory.com
* [@jagregory](http://twitter.com/jagregory)
