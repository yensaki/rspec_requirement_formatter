require "rspec_requirement_formatter/version"
require "rspec"
require "rspec/core/formatters/base_formatter"

require "json"

class RspecRequirementFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self,
                                   :start,
                                   :stop

  attr_reader :output_hash

  def initialize(output)
    super(output)
    @output = output
    @output_hash = {}
  end

  def stop(group_notification)
    @output_hash[:examples] = group_notification.notifications.map do |notification|
      format_example(notification.example)
    end
    @output.write @output_hash.to_json
  end

  private

  def format_example(example)
    {
      id: example.id,
      description: example.description,
      full_description: example.full_description,
      file_path: example.file_path,
      status: example.execution_result.status.to_s,
      line_number: example.metadata[:line_number]
    }
  end
end
