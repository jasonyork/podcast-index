## [Unreleased]

* Add `ostruct` as a runtime dependency (no longer a default gem in Ruby 4.0)
* Update RuboCop and move development dependencies to the Gemfile
* Test against Ruby 3.2, 3.3, 3.4 and 4.0 in CI

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


## [0.2.0] - 2023-04-24

* BREAKING: Switching to be more consistent with ActiveRecord conventions, using `find_by` and `where` methods for all models
* Add support for all "Search", "Podcasts", "Episodes", "Recent" and "Value" sections of the API.  This introduces the `Soundbite` and `Value` domain models.
* Update README.md

## [0.1.0] - 2023-01-06

- Initial release
