require "../../spec_helper"

module Spotippos::Validators
  Spec2.describe SearchValidator do
    let(invalid_params) { {"ax" => 2000, "ay" => 150} }
    let(valid_params) { {"ax" => 100, "ay" => 200, "bx" => 300, "by" => 400} }

    describe "#initialize" do
      subject { SearchValidator.new(invalid_params) }

      it "validates the provided payload" do
        expect(subject.valid?).to eq(false)
        expect(subject.errors).to eq(["{ax} must be between 0 and 1400",
                                      "{bx} missing",
                                      "{by} missing"])
      end
    end

    describe "#valid?" do
      context "when there are errors" do
        subject { SearchValidator.new(invalid_params) }
        it "is false" { expect(subject.valid?).to eq(false) }
      end

      context "when there are no errors" do
        subject { SearchValidator.new(valid_params) }
        it "is true" { expect(subject.valid?).to eq(true) }
      end
    end

    describe "#errors" do
      context "when there are errors" do
        subject { SearchValidator.new(invalid_params) }
        it "returns an error list" { expect(subject.errors.size).to eq(3) }
      end

      context "when there are no errors" do
        subject { SearchValidator.new(valid_params) }
        it "returns an empty list" { expect(subject.errors.size).to eq(0) }
      end
    end
  end
end
