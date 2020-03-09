require "rails_helper"

RSpec.describe User do
  let(:admin) { create(:admin) }
  let(:agent) { create(:agent) }
  let(:customer) { create(:customer) }
  let(:open_ticket) { create(:ticket) }
  let(:closed_ticket) { create(:closed_ticket)}
  let(:processing_ticket) { create(:processing_ticket )}
  let(:ticket_with_comments) { create(:ticket_with_comments) }

  context "Association" do
    it { should have_many(:tickets).with_foreign_key("customer") }
    it { should have_many(:handled_tickets).with_foreign_key("closed_by") }
    it { should have_many(:comments) }
  end

  context "Regarding Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  describe "Scopes" do
    before do
      # list all users to ensure that they are loaded.
      # This is a workaround for the :let lazy-loading which means
      # User.all would be empty
      all_users = [ admin, agent, customer]
    end
    
    describe "Admin scope" do
      it "returns only admin users" do
        User.admins.each do |user|
          expect(user.admin?).to be true
        end
      end
    end

    describe "Agent scope" do
      it "returns only agents" do
        User.agents.each do |user|
          expect(user.agent?).to be true
        end
      end
    end

    describe "Customers scope" do
      it "returns only customers" do
        User.customers.each do |user|
          expect(user.customer?).to be true
        end
      end
    end
  end

  describe "#agent?" do
    it "returns true if user is a support agent" do
      expect(agent.agent?).to be true
    end

    it "returns true if user is an admin" do
      expect(admin.agent?).to be true
    end

    it "returns false if user is neither an admin nor agent" do
      expect(customer.agent?).to be false
    end
  end

  describe "#customer?" do
    it "returns true if user is neither an admin nor agent" do
      expect(customer.customer?).to be true
    end

    it "returns false if user is a support agent" do
      expect(agent.customer?).to be false
    end

    it "returns false if user is an admin" do
      expect(admin.customer?).to be false
    end
  end

  describe "#can_export?" do
    it "returns true if user is a support agent" do
      expect(agent.can_export?).to be true
    end

    it "returns true if user is an admin" do
      expect(admin.can_export?).to be true
    end

    it "returns false if user is neither an admin nor agent" do
      expect(customer.can_export?).to be false
    end
  end

  describe "#can_comment?" do
    context "when the ticket has no comments" do
      it "returns true if user is a support agent" do
        expect(agent.can_comment?(open_ticket)).to be true
      end

      it "returns true if user is an admin" do
        expect(admin.can_comment?(open_ticket)).to be true
      end

      it "returns false if user is neither an admin nor agent" do
        expect(customer.can_comment?(open_ticket)).to be false
      end
    end

    context "when the ticket has comments" do
      it "returns true if user is a support agent" do
        expect(agent.can_comment?(ticket_with_comments)).to be true
      end

      it "returns true if user is an admin" do
        expect(admin.can_comment?(ticket_with_comments)).to be true
      end

      it "returns false if user is neither an admin nor agent" do
        expect(customer.can_comment?(ticket_with_comments)).to be true
      end
    end
  end

  describe "close" do
    context "when user is a customer" do
      it "ticket status remains unchanged" do
        expect(open_ticket.status).to eq("pending")
        
        customer.close(open_ticket)
        expect(open_ticket.status).to eq("pending")
      end

      it "changes processing ticket status to closed" do
        expect(processing_ticket.status).to eq("processing")
        
        customer.close(processing_ticket)
        expect(processing_ticket.status).to eq("processing")
      end
    end

    context "when user is an agent" do
      it "changes open ticket status to closed" do
        expect(open_ticket.status).to eq("pending")

        agent.close(open_ticket)
        expect(open_ticket.status).to eq("closed")
      end

      it "changes processing ticket status to closed" do
        expect(processing_ticket.status).to eq("processing")
        
        agent.close(processing_ticket)
        expect(processing_ticket.status).to eq("closed")
      end
    end
  end

  describe "process" do
    context "when user is a customer" do
      it "changes open ticket status to processing" do
        expect(open_ticket.status).to eq("pending")
        customer.process(open_ticket)
        expect(open_ticket.status).to eq("pending")
      end

      it "changes closed ticket status to processing" do
        expect(closed_ticket.status).to eq("closed")  
        customer.process(closed_ticket)
        expect(closed_ticket.status).to eq("closed")
      end
    end

    context "when user is an agent" do
      it "changes open ticket status to processing" do
        expect(open_ticket.status).to eq("pending")
        agent.process(open_ticket)
        expect(open_ticket.status).to eq("processing")
      end

      it "changes closed ticket status to processing" do
        expect(closed_ticket.status).to eq("closed")
        agent.process(closed_ticket)
        expect(closed_ticket.status).to eq("processing")
      end
    end
  end

  describe "reset" do
    context "when user is a customer" do
      it "changes processing ticket status to pending" do
        expect(processing_ticket.status).to eq("processing")
        customer.reset(processing_ticket)
        expect(processing_ticket.status).to eq("processing")
      end

      it "changes closed ticket status to pending" do
        expect(closed_ticket.status).to eq("closed")
        customer.reset(closed_ticket)
        expect(closed_ticket.status).to eq("closed")
      end
    end

    context "when user is an agent" do
      it "changes processing ticket status to pending" do
        expect(processing_ticket.status).to eq("processing")
        agent.reset(processing_ticket)
        expect(processing_ticket.status).to eq("pending")
      end

      it "changes closed ticket status to pending" do
        expect(closed_ticket.status).to eq("closed")
        agent.reset(closed_ticket)
        expect(closed_ticket.status).to eq("pending")
      end
    end
  end
end
