# LOCAL.FM

Last.fm analog for capturing and displaying playback history statistics from my
local MoodeAudio setup.

## Usage

1. Build:

```
mix deps.get
mix deps.compile
mix compile
```

2. Run:

To get statistics from moode.local:

```
mix stats -a
```

To show stats from CSV file:

```
mix stats -s data.csv
```

To export stats to a CSV file:

```
mix export data.csv
```

You can also run code with:

```
MOODE_CREDS="pi:password" mix run -e "LocalFM.CLI.main([\"--all-time\"])"
```
