# Fluent::Plugin::Leftronic

Leftronic output plugin for Fluentd.

## Installation

    $ fluent-gem install fluent-plugin-leftronic

## parameter

param    |   value
--------|------
access_key|leftronic access key
stream_name|leftronic stream name
value|count key(line or number only)
graph_type|line or number or pie or bar or leaderboard
name_key_pattern|regular expression(pie or bar or leaderboard only)
display_keys|display key(pie or bar or leaderboard only)


## Configuration

    <match leftronic.**>
      type  leftronic
      access_key ${leftronic-access-key} # leftronic access key
      stream_name ${leftronic-stream-name} # leftronic stream_name
      value key_name
    </match>

	<match groupcounter.merged.apache.pv>
	  type copy
	  <store>
	    type  leftronic
	    access_key ${leftronic-access-key} # leftronic access key
	    stream_name ${leftronic-stream-name} # leftronic stream_name
	    graph_type bar # default => line , number , pie , bar , leaderboard
	    name_key_pattern .*_(count)$ # enable => Googlebot_count,Yahoo! Japan_count,smartphone_count disable => Googlebot_rate
	    display_keys {'Yahoo! Japan_count' => 'yahoo','Googlebot_count' => 'google','smartphone_count' => 'スマートフォン数'}
	  </store>
	  <store>
	    type  leftronic
	    access_key ${leftronic-access-key} # leftronic access key
	    stream_name ${leftronic-stream-name} # leftronic stream_name
	    graph_type line # default => line , number , pie , bar , leaderboard
	    value Yahoo! Japan_count
	  </store>
	  <store>
	    type  leftronic
	    access_key ${leftronic-access-key} # leftronic access key
	    stream_name ${leftronic-stream-name} # leftronic stream_name
	    graph_type number # default => line , number , pie , bar , leaderboard
	    value Googlebot_count
	  </store>
	</match>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
