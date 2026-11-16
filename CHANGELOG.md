## [Unreleased]

* Add `enclosure` and `newest` options to `Episode.where(feed_id:)`, and accept an array of feed ids
* Add `enclosure` option to `Episode.where(itunes_id:)`
* Add `podcastguid` option to `Episode.find_by(guid:)`
* Add `similar` option to `Podcast.where(term:)` and `Podcast.where(title:)`
* Add `max` and `start_at` options to `Podcast.where(tag:)`, and `max` to `Podcast.where(medium:)`
* Fix `Episode.find_by(guid:)` ignoring `feedurl`, `feedid` and `fulltext` options
* Fix `Episode.where(recent: true, exclude_string:)` sending the wrong query parameter (now `excludeString`)
* Raise `PodcastNotFound`, `EpisodeNotFound` or `ValueNotFound` instead of `NoMethodError` when `Podcast.find_by`, `Episode.find`, `Episode.find_by` or `Value.find_by` find no match
* Add `ostruct` as a runtime dependency (no longer a default gem in Ruby 4.0)
* Update RuboCop and move development dependencies to the Gemfile
* Test against Ruby 3.3, 3.4 and 4.0 in CI

## [0.5.1] - 2026-01-30

* Remove dependency on ActiveSupport::Configurable

## [0.5.0] - 2024-11-08

* Remove gem version restrictions to support Rails 8

## [0.4.0] - 2024-01-21

* Add Categories to API (thanks @lbrito1)
* Add Category domain model
* Add stats API and domain model

## [0.3.0] - 2023-09-22

* Add `max` parameter to search requests (thanks @lbrito1)

## [0.2.1] - 2023-07-06

* Raise exception when `Podcast.find` returns no result ([#6](https://github.com/jasonyork/podcast-index/issues/6))

## [0.2.0] - 2023-04-24

* BREAKING: Switching to be more consistent with ActiveRecord conventions, using `find_by` and `where` methods for all models
* Add support for all "Search", "Podcasts", "Episodes", "Recent" and "Value" sections of the API.  This introduces the `Soundbite` and `Value` domain models.
* Update README.md

## [0.1.0] - 2023-01-06

- Initial release
