# Ruby Keyboard Reader

## Features
- Human-readable keys log
- Key combinations log
- Hide `SYN_REPORT`, `EV_MSC` and `release` events
- Waiting for one or more keys

## Running
Modify this line with the index at the end of the file name `/dev/input/event` from the target device:
```ruby
device_event_id = 10
```
```sh
$ ruby test.rb
```

## Example
![example screenshot](./example.png)

## Thanks
- [rickhull/device_input](https://github.com/rickhull/device_input)
- [gems/device_input](https://rubygems.org/gems/device_input)
