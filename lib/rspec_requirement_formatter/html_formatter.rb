require 'rspec/core/formatters/base_formatter'
require 'rspec_requirement_formatter/html_printer'

module RspecRequirementFormatter
  class HtmlFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self,
      :example_group_started,
      :example_started,
      :example_passed,
      :example_failed,
      :example_pending,
      :example_group_finished

    def initialize(output)
      super(output)
      @example_group_number = 0
      @example_number = 0
      @group_level = 0
      @examples = []

      @top_groups = {}
      @index_printer = RspecRequirementFormatter::HtmlPrinter.new(output, index: true)
    end

    def example_group_started(notification)
      super
      @example_group_number += 1

      if @group_level == 0
        dir = File.join(@index_printer.dir, "example_groups")
        FileUtils.mkdir_p(dir)
        file = File.open(File.join(dir, "#{notification.group.description.parameterize}.html"), 'w')
        @printer = RspecRequirementFormatter::HtmlPrinter.new(file)
        @examples = []
      end
      @printer.start_example_group_division(notification.group, @group_level)
      @group_level += 1
    end

    def example_started(_notification)
      @example_number += 1
    end

    def example_passed(passed)
      create_example_division(passed.example)
    end

    def example_failed(failed)
      create_example_division(failed.example)
    end

    def example_pending(pending)
      create_example_division(pending.example)
    end

    def example_group_finished(notification)
      @group_level ||= 0
      @group_level -= 1 if @group_level > 0
      @printer.finish_example_group_division(notification.group, @group_level)

      return unless @group_level == 0

      @printer.output(notification)
      @top_groups[notification.group.description.parameterize] = notification.group
    end

    def close(_notification)
      @index_printer.output_index(@top_groups)
    end

    private

    def create_example_division(example)
      @examples << example
      @printer.example_division(example)
    end
  end
end
