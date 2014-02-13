Wercker Step Ikachan
====================

[![wercker status](https://app.wercker.com/status/f9e24f552ca60191bf2b2309ee701ab7/m/ "wercker status")][wercker]
[wercker]: https://app.wercker.com/project/bykey/f9e24f552ca60191bf2b2309ee701ab7

Send a message to an IRC channel by ikachan.

Options
-------

- `server` (required) - The hostname or ip address of the ikachan server.
- `port` (required) - The port of the ikachan server.
- `channel` (required) - The channel that the message will be send to. Do not include '#' sign.
- `passed-message` (optional) - Use this option to override the default passed message.
- `failed-message` (optional) -  Use this option to override the default failed message.
- `on` (optional, default: always) - Possible values: `always` and `failed`.

Example
-------

```yaml
build:
    after-steps:
        - linyows/ikachan:
            server: your.ikachan.com
            port: 4979
            channel: yourchannel
```

License
-------

The MIT License (MIT)
