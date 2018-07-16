require 'erb'
module RspecRequirementFormatter
  class HtmlPrinter
    REQUIREMENTS_PATH = ENV['REQUIREMENTS_PATH'] || './rspec_requirements'

    def initialize
      @body = ""
    end

    def start_example_group_division(example_group, group_level)
      html = ERB.new(group_start_partial).result(binding)
      html = "<tr><td>#{html}" unless group_level == 0
      @body << html
    end

    def example_division(example)
      example_partial = File.read(File.dirname(__FILE__) + '/../../templates/_example.html.erb')
      @body << ERB.new(example_partial).result(binding)
    end

    def finish_example_group_division(_example_group, group_level)
      html = "</tbody></table>"
      html = "#{html}</td></tr>" unless group_level == 0
      @body << html
    end

    def output(notification)
      File.open("#{REQUIREMENTS_PATH}/#{notification.group.description.parameterize}.html", 'w') do |f|
        @title = notification.group.description

        layout_file = File.read(File.dirname(__FILE__) + '/../../templates/layout.html.erb')

        f.puts ERB.new(layout_file).result(binding)
      end
    end

    def group_start_partial
      @group_start_partial ||= File.read(File.dirname(__FILE__) + '/../../templates/_group_start.html.erb')
    end
  end
end