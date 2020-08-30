require "rspec/core/configuration"
require "rspec/core/configuration_options"

module FormatterSupport
  def run_rspec(formatter, output:, spec_path:)
    options = RSpec::Core::ConfigurationOptions.new(
      ["--no-profile", "--format", formatter, "--out", output, "--seed", "42", *spec_path]
    )
    err, out = StringIO.new, StringIO.new
    err.set_encoding("utf-8") if err.respond_to?(:set_encoding)

    runner = RSpec::Core::Runner.new(options)
    runner.run(err, out)
    out.string
  end

  def reporter
    @reporter ||= setup_reporter
  end

  def setup_reporter(*streams)
    streams << config.output_stream if streams.empty?
    config.formatter_loader.add described_class, *streams
    @formatter = config.formatters.first
    @reporter = config.reporter
  end

  def setup_profiler
    config.profile_examples = true
  end

  def formatter_output
    @formatter_output ||= StringIO.new
  end

  def config
    @configuration ||= RSpec::Core::Configuration.new.tap do |config|
      config.output_stream = formatter_output
    end
  end

  def configure
    yield config
  end
end