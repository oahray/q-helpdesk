require 'rails_helper'

feature 'Visitor tries to sign up', type: :feature do
  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'password'

    expect(page).to have_content("Account creation successful")
  end

  scenario 'with blank email and password' do
    sign_up_with '', ''

    expect(page).to have_content("Email and password must not be empty")
  end

  scenario 'with blank email' do
    sign_up_with '', 'password'

    expect(page).to have_content("Email must not be empty")
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', ''

    expect(page).to have_content("Password must not be empty")
  end
end

feature 'Visitor tries to sign in', type: :feature do
  let(:customer) { create(:customer) }

  scenario 'with valid email and password' do
    sign_in_as customer

    expect(page).to have_content("Welcome back")
    expect(page).to have_content(customer.email)
    expect(page).to have_content("My tickets")
  end

  scenario 'with blank email and password' do
    sign_in_with '', ''

    expect(page).to have_content("Email and password must not be empty")
  end

  scenario 'with blank email' do
    sign_in_with '', 'password'

    expect(page).to have_content("Email must not be empty")
  end

  scenario 'with blank password' do
    sign_in_with 'valid@example.com', ''

    expect(page).to have_content("Password must not be empty")
  end
end
