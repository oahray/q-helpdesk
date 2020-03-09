require "rails_helper"

RSpec.describe Comment do
  context "Association" do
    it { should belong_to(:ticket) }
    it { should belong_to(:user) }
  end

  context "Regarding Validations" do
    it { should validate_presence_of(:body) }
  end
end
