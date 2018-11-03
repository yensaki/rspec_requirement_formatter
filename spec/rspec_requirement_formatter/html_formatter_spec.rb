require 'pty'
require 'pry'
require 'rspec_requirement_formatter'

RSpec.describe RspecRequirementFormatter::HtmlFormatter do
  EXAMPLE_DIR = File.expand_path("../../../example/resources", __FILE__)

  before(:all) { ENV.delete("TEST_ENV_NUMBER") }

  let(:formatter_arguments) { ["--format", "RspecRequirementFormatter::HtmlFormatter", "-r", "rspec_requirement_formatter"] }

  describe "produced HTML" do
    let(:expected_html) { File.read('') }
    subject(:actual_html) do
      described_class.new(output)
    end

    def safe_pty(command, directory)
      sio = StringIO.new
      begin
        PTY.spawn(*command, chdir: directory) do |r,w,pid|
          begin
            r.each_line { |l| sio.puts(l) }
          rescue Errno::EIO
          ensure
            ::Process.wait pid
          end
        end
      rescue PTY::ChildExited
      end
      sio.string
    end

    def execute_example_spec
      command = ["bundle", "exec", "rspec", *formatter_arguments]
      safe_pty(command, EXAMPLE_DIR)
    end

    let(:output) { execute_example_spec }


    it "is identical to the one we designed manually" do
      output
    end
  end
end
