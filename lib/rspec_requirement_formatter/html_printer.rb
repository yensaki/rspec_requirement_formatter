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
        @output = File.open("#{REQUIREMENTS_PATH}/index.html", 'w')
      end
      @dir = File.dirname(@output.path)
      @body = ""
      create_path
      create_assets
    end

    def start_example_group_division(example_group, group_level)
      html = ''
      html << "<li class='list-group-item'>" unless group_level == 0
      html << "  <div class='card-header'>#{example_group.description}</div>"
      html << "  <ul class='list-group'>"
      @body << html
    end

    def example_division(example)
      @body << <<-EOS
        <li class="list-group-item">
          <i>#{example.description}</i>
        </li>
      EOS
    end

    def finish_example_group_division(_example_group, group_level)
      html = ''
      html << "  </ul>"
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