# Status page

## Installation

Install nokogiri dependencies, follow the link http://www.nokogiri.org/tutorials/installing_nokogiri.html for details.

Install gem.

```bash
gem install status_page_ruby
```

## Usage

```bash
status-page
```

```text
Commands:
  status-page backup --path=PATH   # Backups data.
  status-page help [COMMAND]       # Describe available commands or one specific command
  status-page history              # Display all the data which was gathered.
  status-page live                 # Pulls, saves and log statuses every 10 seconds.
  status-page pull                 # Pulls, saves and optionally log statuses.
  status-page restore --path=PATH  # Restores data.
  status-page stats                # Summarizes the data and displays it.
```


## Testing

### Setup

```bash
git clone git@github.com:knlynda/status-page-ruby.git
gem install bundler
bundle install
```

### Run rubocop

```bash
bundle exec rubocop
```

### Run rspec tests

```bash
bundle exec rspec
```
