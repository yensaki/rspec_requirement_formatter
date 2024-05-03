require "rspec_requirement_formatter/version"
require "rspec_requirement_formatter/formatter"
require "rspec_requirement_formatter/requirement"

class RspecRequirementFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self,
                                   :start,
                                   :stop

  def initialize(output)
    super(output)
    @output = output
    @hash_group = []
  end

  def stop(group_notification)
    @hash_group << group_notification.notifications.map do |notification|
      format_example(notification.example)
    end
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
