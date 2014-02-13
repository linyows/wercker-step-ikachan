Wercker Step Ikachan
====================

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
