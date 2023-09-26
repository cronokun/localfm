# LOCAL.FM

Last.fm analog for capturing and displaying playback history statistics from my
local MoodeAudio setup.

## Usage

1. Build:

```
mix deps.get
mix deps.compile
mix compile
mix escript.build
```

2. Run:

```
MOODE_CREDS="pi:password" ./localfm -n 20 -d 90
```

or without building escript:

```
MOODE_CREDS="pi:password" mix run -e "LocalFM.CLI.main([\"--all-time\"])"
```
