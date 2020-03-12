require "rails_helper"

RSpec.describe Ticket do
  let(:customer) { create(:customer) }
  let(:agent) { create(:agent) }
  let(:admin) { create(:admin) }
  let(:open_ticket) { create(:ticket) }
  let(:closed_ticket) { create(:closed_ticket)}
  let(:processing_ticket) { create(:processing_ticket )}
  let(:ticket_with_comments) do
    create(:ticket_with_comments, comments_count: 5)
  end
  let(:old_ticket) { create(:three_months_ago_closed_ticket) }

  context "Association" do
    it { should belong_to(:customer) }
    it { should belong_to(:closed_by) }
    it { should have_many(:comments) }
  end

  context "Regarding Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe "Scopes" do
    # list all tickets to ensure that they are loaded.
      # This is a workaround for the :let lazy-loading which means
      # Ticket.all would be empty
    before do
      all_tickets = [
        open_ticket,
        closed_ticket,
        processing_ticket,
        ticket_with_comments,
        old_ticket]
    end
    
    describe "Pending scope" do
      it "returns only pending/open tickets" do
        Ticket.pending.each do |ticket|
          expect(ticket.status).to eq("pending")
        end
      end
    end

    describe "Processing scope" do
      it "returns only tickets that are being processed" do
        Ticket.processing.each do |ticket|
          expect(ticket.status).to eq("processing")
        end
      end
    end

    describe "Closed scope" do
      it "returns only closed tickets" do
        tickets = Ticket.closed
        
        expect(tickets).to include(closed_ticket)
        expect(tickets).to include(old_ticket)

        tickets.each do |ticket|
          expect(ticket.status).to eq("closed")
        end
      end
    end

    describe "Recently closed scope" do
      it "returns only recently closed tickets" do
        tickets = Ticket.recently_closed
        
        expect(tickets).to include(closed_ticket)
        expect(tickets).not_to include(old_ticket)
        
        tickets.each do |ticket|
          expect(ticket.status).to eq("closed")
        end
      end
    end
  end

  describe "#exportable_attributes" do
    it "returns a list of exportable attributes" do
      attrs = %w{# title description comments_count customer created_at status}

      expect(Ticket.exportable_attributes).to eq(attrs)
    end

    it "returns a frozen list" do
      expect(Ticket.exportable_attributes.frozen?).to be true
    end
  end

  describe "#csv_data" do
    it "returns an array of instance data to be exported as csv" do
      expect(closed_ticket.csv_data).to be_a(Array)
    end

    it "contains correct data" do
      expected_data = [
        closed_ticket.id,
        closed_ticket.title,
        closed_ticket.description,
        closed_ticket.comments_count,
        closed_ticket.customer.email,
        closed_ticket.created_at.utc.getlocal.
          strftime("%-I:%M %P - %A %B %d, %Y"),
        closed_ticket.status
      ]

      expect(closed_ticket.csv_data).to match(expected_data)
    end
  end

  describe "#commentable?" do
    context "when ticket has no comments" do
      it "returns true if user is a support agent" do
        expect(open_ticket.commentable?(agent)).to be true
      end

      it "returns true if user is an admin" do
        expect(open_ticket.commentable?(agent)).to be true
      end

      it "returns false if user is a customer" do
        expect(open_ticket.commentable?(customer)).to be false
      end
    end

    context "when ticket has comments" do
      it "returns true if user is a support agent" do
        expect(ticket_with_comments.commentable?(agent)).to be true
      end

      it "returns true if user is an admin" do
        expect(ticket_with_comments.commentable?(agent)).to be true
      end

      it "returns false if user is a customer" do
        expect(ticket_with_comments.commentable?(customer)).to be true
      end
    end
  end

  describe "#comments_count" do
    context "when ticket has no comments" do
      it "returns zero" do
        expect(open_ticket.comments_count).to be 0
      end
    end

    context "when ticket has comments" do
      it "returns zero" do
        expect(ticket_with_comments.comments_count).to be 5
      end
    end
  end

  describe "#has_comments?" do
    context "when ticket has no comments" do
      it "returns false" do
        expect(open_ticket.has_comments?).to be false
      end
    end

    context "when ticket has comments" do
      it "returns zero" do
        expect(ticket_with_comments.has_comments?).to be true
      end
    end
  end

  describe "#open?" do
    context "when ticket is pending" do
      it "returns true" do
        expect(open_ticket.open?).to be true
      end
    end

    context "when ticket is processing" do
      it "returns false" do
        expect(processing_ticket.open?).to be false
      end
    end

    context "when ticket is closed" do
      it "returns false" do
        expect(closed_ticket.open?).to be false
      end
    end
  end

  describe "#status" do
    it "returns pending for open tickets" do
      expect(open_ticket.status).to eq("pending")
    end

    it "returns processing for processing tickets" do
      expect(processing_ticket.status).to eq("processing")
    end

    it "returns closed for closed tickets" do
      expect(closed_ticket.status).to eq("closed")
    end
  end

  # This is a concern method available in models that include CsvExportable
  describe "#to_csv" do
    it "returns a csv string" do
      ticket = closed_ticket
      csv_string = Ticket.to_csv([ticket])
      
      expect(csv_string).to be_a(String)
      expect(csv_string).to include(ticket.title, ticket.status, ticket.customer.email)
    end
  end
end
