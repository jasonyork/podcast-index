## [Unreleased]

## [0.2.1] - 2023-07-06

* Raise exception when `Podcast.find` returns no result ([#6](https://github.com/jasonyork/podcast-index/issues/6))

## [0.2.0] - 2023-04-24

* BREAKING: Switching to be more consistent with ActiveRecord conventions, using `find_by` and `where` methods for all models
* Add support for all "Search", "Podcasts", "Episodes", "Recent" and "Value" sections of the API.  This introduces the `Soundbite` and `Value` domain models.
* Update README.md

## [0.1.0] - 2023-01-06

- Initial release
