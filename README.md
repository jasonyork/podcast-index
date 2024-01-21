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

This client currently implements the following sections of the API:
* [Search](https://podcastindex-org.github.io/docs-api/#tag--Search)
* [Podcasts](https://podcastindex-org.github.io/docs-api/#tag--Podcasts)
* [Episodes](https://podcastindex-org.github.io/docs-api/#tag--Episodes)
* [Recent](https://podcastindex-org.github.io/docs-api/#tag--Recent)
* [Value](https://podcastindex-org.github.io/docs-api/#tag--Value)
* [Categories](https://podcastindex-org.github.io/docs-api/#tag--Categories)

These are exposed through the following domain models:
* [Episode](lib/podcast_index/episode.rb)
* [Podcast](lib/podcast_index/podcast.rb)
* [Soundbite](lib/podcast_index/soundbite.rb)
* [Value](lib/podcast_index/value.rb)
* [Category](lib/podcast_index/category.rb)

The intent is to follow ActiveRecord conventions as reasonably possible.  Therefore, most of the requests are accessed through the model's `.find_by` and `.where` methods.

### Examples

Find a podcast by podcastindex id:

```ruby
podcast = PodcastIndex::Podcast.find(920666)
podcast.title # => "Podcasting 2.0"
```

When the podcast cannot be found:

```ruby
begin
  podcast = PodcastIndex::Podcast.find("invalid")
rescue PodcastIndex::PodcastNotFound
  puts "Podcast not found"
end
```

Find an episode by guid:

```ruby
episode = PodcastIndex::Episode.find_by(guid: "PC2084", feedurl: "http://mp3s.nashownotes.com/pc20rss.xml")
episode.title # => "Episode 84: All Aboard to On-Board!"
```

Find a Value block by feed_id:

```ruby
value = PodcastIndex::Value.find_by(feed_id: 920666)
value.model.type # => "lightning"
```

Methods that return multiple results are represented as an array of objects:

```ruby
episodes = PodcastIndex::Episode.where(person: "Adam Curry")
episodes.count # => 57
episodes.first.title # => "Episode #2: A conversation with Adam Curry"
```

```ruby
soundbite = PodcastIndex::Soundbite.where(recent: true)
soundbite.first.episode_id # => 15082076307
```

### Supported Methods

```ruby
# Episode
Episode.find(id, fulltext: nil)
Episode.find_by(guid, feedurl: nil, feedid: nil, fulltext: nil)
Episode.where(feed_id:, since: nil, max: nil, fulltext: nil)
Episode.where(feed_url:, since: nil, max: nil, fulltext: nil)
Episode.where(podcast_guid:, since: nil, max: nil, fulltext: nil)
Episode.where(live: true, max: nil)
Episode.where(itunes_id:, since: nil, max: nil, fulltext: nil)
Episode.where(person:, fulltext: nil)
Episode.where(recent: true, max: nil, exclude_string: nil, before: nil, fulltext: nil)
Episode.sample(max: nil, lang: nil, categories: [], exclude_categories: [], fulltext: nil) # Find a random episode

# Podcast
Podcast.find(id)
Podcast.find_by(feed_url)
Podcast.find_by(guid)
Podcast.find_by(itunes_id)
Podcast.where(tag:)
Podcast.where(medium:)
# Additional parameters only for searching with "music" medium
Podcast.where(medium: "music", term:, val: nil, aponly: nil, clean: nil, fulltext: nil) 
Podcast.where(term:, val: nil, aponly: nil, clean: nil, fulltext: nil)
Podcast.where(title:, val: nil, clean: nil, fulltext: nil)
Podcast.where(trending: true, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
Podcast.where(dead: true)
Podcast.where(recent: true, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
Podcast.where(new: true, max: nil, since: nil, feedid: nil, desc: nil)
Podcast.where(newly_found: true, max: nil, since: nil)

# Soundbite
Soundbite.where(recent: true, max: nil)

# Value
Value.find_by(feed_id)
Value.find_by(feed_url)

# Category
Category.all
Category.find(category_id)
```

The attributes of the models mirror the names in the API, but have been translated to "underscore" format to more closely follow Ruby conventions.  For example, the `lastUpdateTime` attribute for a `Podcast` is exposed as `last_update_time`.

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
