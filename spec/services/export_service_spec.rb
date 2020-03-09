require "rails_helper"

RSpec.describe ExportService do
  let(:admin) { create(:admin) }
  let(:agent) { create(:agent) }
  let(:customer) { create(:customer) }
  let(:closed_ticket) { create(:closed_ticket)}

  describe "#to_csv" do
    it "raises error if user is not an agent" do
      expect do
        ExportService.new(content: [closed_ticket], user: customer).to_csv
      end.to raise_error(CustomError::Unauthorized)
    end

    it "returns a csv string" do
      ticket = closed_ticket
      csv_string = ExportService.new(content: [ticket], user: agent).to_csv
      
      expect(csv_string).to be_a(String)

      expect(csv_string).to include(ticket.title, ticket.status, ticket.customer.email)
    end
  end
end
