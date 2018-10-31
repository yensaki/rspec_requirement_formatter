RSpec.describe RspecRequirementFormatter::HtmlFormatter do
  describe "produced HTML" do
    let(:expected_html) { File.read('') }
    subject(:actual_html) do
      described_class.new(output)
    end
    let(:output) { }

    it "is identical to the one we designed manually" do
      is_expected.to eq(expected_html)
    end
  end
end
