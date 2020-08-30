require 'pty'
require 'pry'
require 'rspec_requirement_formatter'

RSpec.describe RspecRequirementFormatter::Formatter do
  EXAMPLE_DIR = File.expand_path("../../../example/resources", __FILE__)

  before(:all) { ENV.delete("TEST_ENV_NUMBER") }

  let(:formatter_arguments) { ["--format", "RspecRequirementFormatter::Formatter", "--out", output_path]}

  let(:output_path) { File.join(EXAMPLE_DIR, "output.json") }

  describe "produced JSON" do
    let(:expected_file_path) { File.expand_path('../../fixtures/output.json', __FILE__) }
    let(:expected_file) { File.read(expected_file_path) }
    let(:actual_file) do
      File.read(output_path)
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

    it 'generate JSON' do
      execute_example_spec
      expect(actual_file).to eq expected_file
    end
  end
end
