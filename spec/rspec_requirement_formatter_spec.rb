require 'pry'
require 'json'
require 'rspec/core/reporter'

require 'rspec_requirement_formatter'
# require '../support/formatter_support'

RSpec.describe RspecRequirementFormatter do
  include FormatterSupport

  it "has a version number" do
    expect(RspecRequirementFormatter::VERSION).not_to be nil
  end

  describe "output" do
    context "When simple RSpec group," do
      let!(:expected_file_path) { File.expand_path('./../fixtures/expected/simple_example_group.json', __FILE__) }
      let!(:expected_file) { File.read(expected_file_path) }

      it "generates formatted JSON" do
        group = RSpec.describe("one apiece") do
          it("succeeds") { expect(1).to eq 1 }
        end
        reporter.report(2) do |r|
          group.run(r)
        end
        examples_json = JSON.parse(formatter_output.string)["examples"]
        example_json = examples_json.first
        expect(example_json).to eq JSON.parse(expected_file)
      end
    end
  end
end
