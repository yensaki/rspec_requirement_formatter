require 'rspec/core/formatters/base_formatter'
require 'rspec_requirement_formatter/html_printer'
require 'erb'

module RspecRequirementFormatter
  class HtmlFormatter < RSpec::Core::Formatters::BaseFormatter
    REQUIREMENTS_PATH = ENV['REQUIREMENTS_PATH'] || './rspec_requirements'

    RSpec::Core::Formatters.register self,
      :example_group_started,
      :example_started,
      :example_passed,
      :example_failed,
      :example_pending,
      :example_group_finished

    def initialize(output)
      super(output)
      create_path
      create_assets
      @example_group_number = 0
      @example_number = 0
      @group_level = 0
      @examples = []

      @top_groups = {}
      @printer = RspecRequirementFormatter::HtmlPrinter.new
    end

    def example_group_started(notification)
      super
      @example_group_number ||= 0
      @example_group_number += 1

      if @group_level == 0
        @printer = RspecRequirementFormatter::HtmlPrinter.new
        @examples = []
      end
      @printer.start_example_group_division(notification.group, @group_level)
      @group_level += 1
    end

    def example_started(_notification)
      @example_number += 1
    end

    def example_passed(passed)
      example = passed.example
      @examples << example
      @printer.example_division(example)
    end

    def example_failed(failed)
      example = failed.example
      @examples << example
      @printer.example_division(example)
    end

    def example_pending(pending)
      example = pending.example
      @examples << example
      @printer.example_division(example)
    end

    def example_group_finished(notification)
      @group_level ||= 0
      @group_level -= 1 if @group_level > 0
      @printer.finish_example_group_division(notification.group, @group_level)

      return unless @group_level == 0

      @printer.output(notification)
      @top_groups[notification.group.description.parameterize] = notification.group
    end

    def close(notification)
      File.open("#{REQUIREMENTS_PATH}/index.html", 'w') do |f|
        template_file = File.read(File.dirname(__FILE__) + '/../../templates/index.html.erb')
        f.puts ERB.new(template_file).result(binding)
      end
    end

    private

    def create_path
      FileUtils.mkdir_p(REQUIREMENTS_PATH)
    end

    def create_assets
      dest_dir = "#{REQUIREMENTS_PATH}"
      FileUtils.mkdir_p(dest_dir)
      FileUtils.cp_r(File.dirname(__FILE__) + '/../../assets/', dest_dir)
    end
  end
end
