# Live specs call the real podcastindex.org API. They are excluded from the default run;
# run them with `bundle exec rake spec:live`, with API_KEY and API_SECRET set in the
# environment or in a .env file at the project root.
module LiveApiEnv
  # Reads KEY=VALUE lines literally. Unlike dotenv, `$` is not expanded, since API secrets can contain it.
  def self.load(path)
    return unless File.exist?(path)

    File.foreach(path) do |line|
      key, value = line.strip.split("=", 2)
      next if value.nil? || key.start_with?("#")

      ENV[key] ||= unquote(value)
    end
  end

  def self.unquote(value)
    quoted = value.length >= 2 && value[0] == value[-1] && ["'", '"'].include?(value[0])
    quoted ? value[1..-2] : value
  end
end

RSpec.configure do |config|
  if ENV["LIVE_API"]
    LiveApiEnv.load(File.expand_path("../../.env", __dir__))

    missing = %w[API_KEY API_SECRET].reject { |key| ENV[key].present? }
    abort "Live specs need #{missing.join(" and ")} (set them in the environment or .env)" if missing.any?
  else
    config.filter_run_excluding :live
  end

  config.around(:each, :live) do |example|
    WebMock.allow_net_connect!
    PodcastIndex.configure do |c|
      c.api_key = ENV.fetch("API_KEY")
      c.api_secret = ENV.fetch("API_SECRET")
    end
    example.run
  ensure
    WebMock.disable_net_connect!
  end
end
