require "rspec_requirement_formatter/version"

require "rspec"
require "rspec/core/formatters/base_formatter"

class RspecRequirementFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self,
                                   :example_group_started,
                                   :example_started,
                                   :example_passed,
                                   :example_failed,
                                   :example_pending,
                                   :example_group_finished

  def initialize(output)
    super(output)
  end

  def example_group_started(notification)
    super
  end

  def example_started(notification)
  end

  def example_passed(passed)
  end

  def example_failed(failed)
  end

  def example_pending(pending)
  end

  def example_group_finished(notification)
  end

  def close(notification)
  end
end
