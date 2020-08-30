require 'pry'
require 'json'
require 'rspec/core/reporter'

require 'rspec_requirement_formatter'
# require '../support/formatter_support'

RSpec.describe RspecRequirementFormatter::Formatter do
  include FormatterSupport

  describe "produced JSON" do
    let(:expected_file_path) { File.expand_path('../../fixtures/expected.json', __FILE__) }
    let(:expected_file) { File.read(expected_file_path) }

    it 'generate JSON' do
      its = []
      group = RSpec.describe("one apiece") do
        its.push it("succeeds") { expect(1).to eq 1 }
      end
      reporter.report(2) do |r|
        group.run(r)
      end
      # run_rspec(described_class.to_s, output: output_path, spec_path: [example_spec_file_path])
      expect(formatter_output.string).to eq expected_file
    end
  end
end
