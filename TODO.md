# Local.FM • TODO / Project Management


## (A) MVP [100%]

- [x] Get playback history from RPi4
- [x] Parse playback history
- [x] Calculate playback stats
- [x] Output stats (plain text)

### Improvements [60%]

- [x] More options (date ranges, list length, etc.)
- [x] Better/prettier CLI output
- [ ] Show total stats
- [x] Show last played
- [ ] Show favorites (is it possible?)

### Tech Debts / Tech improvements

- [ ] Add tests __@doing__
- [ ] Extract creds to config files
- [ ] ...and push to Github repo
- [ ] Different downloader? (instead of CURL)


## (B) Next version / HTML

- [ ] Simple HTML output
- [ ] Show album covers
- [ ] Show artist images


- - -

## Testing the project

1. Unit tests:

Start by small independent modules that don't need mocking.

- [x] `cli/config.ex`
- [ ] `output/text.ex`
- [ ] `cli.ex`
- [x] `date_range.ex`
- [ ] `downloader.ex`
- [x] `parser.ex`
- [x] `stats.ex`
