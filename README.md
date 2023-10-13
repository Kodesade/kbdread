# Ruby Keyboard Reader

## Features
- Human-readable keys log
- Key combinations log
- Hide `SYN_REPORT`, `EV_MSC` and `release` events

## Running
```sh
$ ruby reader.rb {index}
```
**index** : id from `/dev/input/event` device file

## Example
![example screenshot](./example.png)

## Thanks
- [rickhull/device_input](https://github.com/rickhull/device_input)
- [gems/device_input](https://rubygems.org/gems/device_input)
