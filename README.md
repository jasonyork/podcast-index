# PodcastIndex

A Ruby client for the [podcastindex.org API](https://podcastindex-org.github.io/docs-api)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add podcast_index

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install podcast_index

## Configuration

Configure the [podcastindex.org API credentials](https://podcastindex-org.github.io/docs-api/#overview--authentication-details) before making any requests:

```ruby
PodcastIndex.configure do |config|
  config.api_key = "<your api key>"
  config.api_secret = "<your api secret>"
end
```

Additionally, the base url of the API defaults to `https://api.podcastindex.org/api/1.0`, but can be overridden in the configure block if necessary:
```ruby
  config.base_url = "<new base url>"
````

In a Rails app, this configuration would typically be placed in an initializer file.

## Usage

### Examples

Find a podcast by podcastindex id:

```ruby
podcast = PodcastIndex::Podcast.find(920666)
podcast.title # => "Podcasting 2.0"
```

Find an episode by guid:

```ruby
episode = PodcastIndex::Episode.find_by_guid("PC2084", feedurl: "http://mp3s.nashownotes.com/pc20rss.xml")
episode.title # => "Episode 84: All Aboard to On-Board!"
```

Methods that return multiple results are represented as an array of objects:

```ruby
episodes = PodcastIndex::Episode.find_by_person("Adam Curry")
episodes.count # => 57
episodes.first.title # => "Episode #2: A conversation with Adam Curry"
```

### Supported Methods

This client currently implements most of the API, focusing on searching for Podcasts and Episodes.  For the list of supported methods, see the [Podcast](lib/podcast_index/podcast.rb) and [Episode](lib/podcast_index/episode.rb) models.

The attributes of the response object mirror the names in the API, but have been translated to "underscore" format more closely follow Ruby conventions.  For example, the `lastUpdateTime` attribute for a `Podcast` is renamed to `last_update_time`.

### Exception Handling

If an error occurs, the client will raise a `PodcastIndex::Error` exception.  The `message` field will contain the description returned from the server if available, or the exception message.  For example, some request require one of three optional params:

```ruby
begin
  episode = PodcastIndex::Episode.find_by_guid("PC2084")
rescue PodcastIndex::Error => e
  puts e.message # => "This call requires either a valid `feedid`, `feedurl` or `podcastguid` argument. "
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jasonyork/podcast_index.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
