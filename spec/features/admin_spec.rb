require 'rails_helper'

feature 'Non-admin users cannot visit the Admin dashboard:', type: :feature do
  let(:customer) { create(:customer) }
  let(:agent) { create(:agent) }

  scenario 'customers cannot see the link' do
    sign_in_as customer

    expect(page).to have_content("My tickets")
    click_on customer.email
    expect(page).not_to have_content("Admin dashboard")
  end

  scenario 'customers cannot visit the Admin page' do
    sign_in_as customer

    visit admin_dashboards_path

    expect(page).to have_content("Insufficient permissions to carry out that action")
    expect(page.current_path).to eq(tickets_path)
  end

  scenario 'agents cannot see the link' do
    sign_in_as agent

    expect(page).to have_content("All tickets")
    click_on agent.email
    expect(page).not_to have_content("Admin dashboard")
  end

  scenario 'agents cannot visit the Admin page' do
    sign_in_as agent

    visit admin_dashboards_path

    expect(page).to have_content("Insufficient permissions to carry out that action")
    expect(page.current_path).to eq(tickets_path)
  end
end

feature 'Admin users can visit the Admin dashboard:', type: :feature do
  let(:admin) { create(:admin) }

  scenario 'admin can see the link' do
    sign_in_as admin

    expect(page).to have_content("All tickets")
    click_on admin.email
    expect(page).to have_content("Admin dashboard")
    
    click_on "Admin dashboard"
    expect(page.current_path).to eq(admin_dashboards_path)
  end

  scenario 'admin can visit the dashboard path' do
    sign_in_as admin

    visit admin_dashboards_path

    expect(page).not_to have_content("Insufficient permissions to carry out that action")
    expect(page.current_path).to eq(admin_dashboards_path)
  end
end
