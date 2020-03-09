require "rails_helper"

RSpec.describe TicketService do
  let(:agent) { create(:agent) }
  let(:customer) { create(:customer) }
  let(:open_ticket) { create(:ticket) }
  let(:closed_ticket) { create(:closed_ticket)}
  let(:processing_ticket) { create(:processing_ticket )}
  let(:service) { TicketService }

  describe "process" do
    context "when user is a customer" do
      it "raises CustomError::Unauthorized error" do
        expect do
          service.new(ticket: [open_ticket], user: customer).process
        end.to raise_error(CustomError::Unauthorized)
      end
    end

    context "when user is an agent" do
      it "changes ticket status to processing" do
        expect(open_ticket.status).to eq("pending")
        
        service.new(ticket: open_ticket, user: agent).process
        expect(open_ticket.status).to eq("processing")
      end
    end
  end

  describe "close" do
    context "when user is a customer" do
      it "raises CustomError::Unauthorized error" do
        expect do
          service.new(ticket: [open_ticket], user: customer).close
        end.to raise_error(CustomError::Unauthorized)
      end
    end

    context "when user is an agent" do
      it "changes open ticket status to closed" do
        expect(open_ticket.status).to eq("pending")

        service.new(ticket: open_ticket, user: agent).close
        expect(open_ticket.status).to eq("closed")
      end
    end
  end

  describe "reset" do
    context "when user is a customer" do
      it "raises CustomError::Unauthorized error" do
        expect do
          service.new(ticket: [closed_ticket], user: customer).reset
        end.to raise_error(CustomError::Unauthorized)
      end
    end

    context "when user is an agent" do
      it "changes open ticket status to closed" do
        expect(closed_ticket.status).to eq("closed")

        service.new(ticket: closed_ticket, user: agent).reset
        expect(closed_ticket.status).to eq("pending")
      end
    end
  end
end
