require 'erb'
module RspecRequirementFormatter
  class HtmlPrinter
    REQUIREMENTS_PATH = './rspec_requirements'

    attr_reader :dir

    def initialize(output)
      if output.is_a?(File)
        @output = output
      else
        FileUtils.mkdir_p(REQUIREMENTS_PATH)
        @output =  File.open("#{REQUIREMENTS_PATH}/index.html", 'w')
      end
      @dir = File.dirname(@output.path)
      @body = ""
      create_path
      create_assets
    end

    def start_example_group_division(example_group, group_level)
      @body << "<li class='list-group-item'>" unless group_level == 0
      @body << "<div class='card-header'>#{example_group.description}</div>"
      @body << "<ul class='list-group'>"
    end

    def example_division(example)
      example_partial = File.read(File.dirname(__FILE__) + '/../../templates/_example.html.erb')
      @body << ERB.new(example_partial).result(binding)
    end

    def finish_example_group_division(_example_group, group_level)
      html = "</ul>"
      html << "</li>" unless group_level == 0
      @body << html
    end

    def output(notification)
      @title = notification.group.description

      layout_file = File.read(File.dirname(__FILE__) + '/../../templates/layout.html.erb')

      @output.puts ERB.new(layout_file).result(binding)
    end

    def output_index(top_groups)
      template_file = File.read(File.dirname(__FILE__) + '/../../templates/index.html.erb')
      @output.puts ERB.new(template_file).result(binding)
    end

    def group_start_partial
      @group_start_partial ||= File.read(File.dirname(__FILE__) + '/../../templates/_group_start.html.erb')
    end

    private

    def create_path
      FileUtils.mkdir_p(@dir)
    end

    def create_assets
      FileUtils.mkdir_p(@dir)
      FileUtils.cp_r(File.dirname(__FILE__) + '/../../assets/', @dir)
    end
  end
end