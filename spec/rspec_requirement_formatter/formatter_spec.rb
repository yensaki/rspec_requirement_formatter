require 'pry'
require 'json'
require 'rspec/core/reporter'

require 'rspec_requirement_formatter'
# require '../support/formatter_support'

RSpec.describe RspecRequirementFormatter::Formatter do
  include FormatterSupport

  describe "produced JSON" do
    EXAMPLE_DIR = File.expand_path("../../../example/resources/*_spec.rb", __FILE__)

    let(:output_path) { File.expand_path('../../fixtures/actual.json', __FILE__) }
    let(:expected_file_path) { File.expand_path('../../fixtures/output.json', __FILE__) }
    let(:expected_file) { File.read(expected_file_path) }
    let(:actual_file) do
      File.read(output_path)
    end

    it 'generate JSON' do
      run_rspec(described_class.to_s, output: output_path, spec_path: [EXAMPLE_DIR])
      expect(actual_file).to eq expected_file
    end
  end
end
