require "rails_helper"
require "date"

RSpec.describe ApplicationHelper, :type => :helper  do
  include ApplicationHelper

  describe "#bootstrap_class_for_flash" do
    it "returns 'alert-success' for success" do
      expect(bootstrap_class_for_flash("success")).
        to eq("alert-success")
    end

    it "returns 'alert-warning' for warning" do
      expect(bootstrap_class_for_flash("warning")).
        to eq("alert-warning")
    end

    it "returns 'alert-warning' for alert" do
      expect(bootstrap_class_for_flash("alert")).
        to eq("alert-warning")
    end

    it "returns 'alert-danger' for error" do
      expect(bootstrap_class_for_flash("error")).
        to eq("alert-danger")
    end

    it "returns 'alert-info' for notice" do
      expect(bootstrap_class_for_flash("notice")).
        to eq("alert-info")
    end

    it "returns original string for other cases" do
      expect(bootstrap_class_for_flash("ray")).
        to eq("ray")
    end
  end

  describe "#format_time" do
    context "when object is not a time or date object" do
      it "returns the original object" do
        expect(format_time("hi")).to eq('hi')
        expect(format_time([])).to eq([])
      end
    end

    context "when a a time or date object is passed in" do
      it "returns a formatted string" do
        time = DateTime.parse("10/03/2020 10:00+1:00")

        expect(format_time(time)).to eq("10:00 am - Tuesday March 03, 2020")
      end
    end
  end
