require 'pry'
require 'json'
require 'rspec/core/reporter'

require 'rspec_requirement_formatter'
# require '../support/formatter_support'

RSpec.describe RspecRequirementFormatter do
  include FormatterSupport

  describe "output" do
    context "When simple RSpec group," do
      let!(:expected_file_path) { File.expand_path('../../fixtures/expected/simple_example_group.json', __FILE__) }
      let!(:expected_file) { File.read(expected_file_path) }

      it "generates formatted JSON" do
        group = RSpec.describe("one apiece") do
          it("succeeds") { expect(1).to eq 1 }
        end
        reporter.report(2) do |r|
          group.run(r)
        end
        expect(JSON.parse(formatter_output.string)["example_groups"]).to eq JSON.parse(expected_file)
      end
    end

    context "When nested RSpec groups," do
      let!(:expected_file_path) { File.expand_path('../../fixtures/expected/nested_example_groups.json', __FILE__) }
      let!(:expected_file) { File.read(expected_file_path) }

      it "generates formatted JSON" do
        group = RSpec.describe("one apiece") do
          it("succeeds") { expect(1).to eq 1 }

          context "context1" do
            context "context1-1" do
              it("context1-1_example1") { expect(1).to eq 1 }
            end

            context "context1-2" do
              it("context1-2_example1") { expect(1).to eq 1 }
              it("context1-2_example2") { expect(1).to eq 1 }
            end

            it("context1_example1") { expect(1).to eq 1 }
          end
        end
        reporter.report(2) do |r|
          group.run(r)
        end
        expect(JSON.parse(formatter_output.string)["example_groups"]).to eq JSON.parse(expected_file)
      end
    end
  end
end
