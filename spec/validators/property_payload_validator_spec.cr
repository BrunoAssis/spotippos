require "../../spec_helper"

module Spotippos::Validators
  Spec2.describe PropertyPayloadValidator do
    let(invalid_payload) { {"title" => "I have a title", "x" => 2000} }
    let(valid_payload) do
      {
        "title"        => "I have a title",
        "description"  => "I have a description",
        "price"        => 200_000,
        "x"            => 200,
        "y"            => 100,
        "beds"         => 3,
        "baths"        => 3,
        "squareMeters" => 100,
      }
    end

    describe "#initialize" do
      subject { PropertyPayloadValidator.new(invalid_payload) }

      it "validates the provided payload" do
        expect(subject.valid?).to eq(false)
        expect(subject.errors).to eq(["{description} missing",
                                      "{price} missing",
                                      "{x} must be between 0 and 1400",
                                      "{y} missing",
                                      "{beds} missing",
                                      "{baths} missing",
                                      "{squareMeters} missing"])
      end
    end

    describe "#valid?" do
      context "when there are errors" do
        subject { PropertyPayloadValidator.new(invalid_payload) }
        it "is false" { expect(subject.valid?).to eq(false) }
      end

      context "when there are no errors" do
        subject { PropertyPayloadValidator.new(valid_payload) }
        it "is true" { expect(subject.valid?).to eq(true) }
      end
    end

    describe "#errors" do
      context "when there are errors" do
        subject { PropertyPayloadValidator.new(invalid_payload) }
        it "returns an error list" { expect(subject.errors.size).to eq(7) }
      end

      context "when there are no errors" do
        subject { PropertyPayloadValidator.new(valid_payload) }
        it "returns an empty list" { expect(subject.errors.size).to eq(0) }
      end
    end
  end
end
