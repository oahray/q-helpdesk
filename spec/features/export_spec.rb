require 'rails_helper'

feature 'Customer cannot see the export buttons', type: :feature do
  let(:customer) { create(:customer) }

  scenario 'with valid email and password' do
    sign_in_as customer

    expect(page).to have_content("My tickets")
    expect(page).not_to have_content("Export CSV")
    expect(page).not_to have_content("Export PDF")
  end
end

feature 'Agent and Admin can export:', type: :feature do
  let(:agent) { create(:agent) }
  let(:admin) { create(:agent) }
  let(:customer) { create(:agent) }

  before do
    @pending_ticket = create(:pending_ticket, customer: customer)
    @closed_ticket = create(:closed_ticket, customer: customer)
    @old_ticket = create(:three_months_ago_closed_ticket, customer: customer)
  end

  after { Capybara.reset_sessions! }

  scenario 'Agent can export CSV' do
    sign_in_as agent

    expect(page).to have_content("All tickets")
    expect(page).to have_content("Export CSV")

    click_on "Export CSV"
  end

  scenario 'Admin can export CSV' do
    sign_in_as agent

    expect(page).to have_content("All tickets")
    click_on "Recently closed"
    expect(page).to have_content("Export CSV")

    click_on "Export CSV"
  end

  scenario 'Agent can export PDF' do
    sign_in_as agent

    expect(page).to have_content("All tickets")
    click_on "Recently closed"
    expect(page).to have_content("Export PDF")

    click_on "Export PDF"
  end

  scenario 'Admin can export PDF' do
    sign_in_as agent

    expect(page).to have_content("All tickets")
    expect(page).to have_content("Export PDF")

    click_on "Export PDF"
  end

  private

  def logout(user)
    click_on user.email
    click_on "Logout"
  end
end
