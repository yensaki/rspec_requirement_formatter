require "rspec"
require "rspec/core/formatters/base_formatter"

module RspecRequirementFormatter
  class Formatter< RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self,
                                     :example_group_started,
                                     :example_started,
                                     :example_passed,
                                     :example_failed,
                                     :example_pending,
                                     :example_group_finished

    def initialize(output)
      super(output)
      @output = output
      @requirement = RspecRequirementFormatter::Requirement.new
    end

    def example_group_started(notification)
      super
      @requirement.add(@example_group) if @example_group.top_level?
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
      @output.write @requirement.to_json
    end
  end
end
