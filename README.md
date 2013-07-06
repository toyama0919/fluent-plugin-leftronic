# Fluent::Plugin::Leftronic

Leftronic output plugin for Fluentd.

## Installation

    $ fluent-gem install fluent-plugin-leftronic

## Configuration

    <match leftronic.**>
      type  leftronic
      access_key ${leftronic-access-key} # leftronic access key
      stream_name ${leftronic-stream-name} # leftronic stream_name
      count key_name
    </match>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
