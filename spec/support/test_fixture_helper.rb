module TestFixtureHelper
  def file_fixture(filename)
    File.open(File.expand_path("../fixtures/files/#{filename}", __dir__), "r:UTF-8")
  end
end
