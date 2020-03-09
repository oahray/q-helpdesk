require 'rails_helper'

feature 'Customer navigates to new ticket page by clicking a button', type: :feature do
  let(:customer) { create(:customer) }

  scenario 'with valid email and password' do
    sign_in_as customer

    expect(page).to have_content("My tickets")
    click_link("New Ticket")
    expect(page.current_path).to eq(new_ticket_path)
    expect(page).to have_content("Open new ticket")
  end
end

feature 'Customer tries to creates new ticket', type: :feature do
  let(:customer) { create(:customer) }

  before do
    sign_in_as customer
    visit new_ticket_path
  end

  scenario 'with empty title and description' do
    fill_in 'title', with: ""
    fill_in 'description', with: ""
    click_on "Create ticket"

    expect(page).to have_content("Title can't be blank and Description can't be blank")
  end

  scenario 'with empty title' do
    fill_in 'title', with: ""
    fill_in 'description', with: "Some description"
    click_on "Create ticket"

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'with empty description' do
    fill_in 'title', with: "Some title"
    fill_in 'description', with: ""
    click_on "Create ticket"

    expect(page).to have_content("Description can't be blank")
  end

  scenario 'with valid title and description' do
    fill_in 'title', with: "Some title"
    fill_in 'description', with: "Some description"
    click_on "Create ticket"

    expect(page.current_path).to eq(ticket_path(Ticket.last))
    expect(page).to have_content("New ticket successfully created")
    expect(page).to have_content("Ticket status: pending")
    expect(page).to have_content("Back to tickets page")
    expect(page).to have_content("Some title")
    expect(page).to have_content("Comments disabled until a support agent comments")
  end
end

feature 'Customer tries to comment on ticket', type: :feature do
  let(:customer) { create(:customer) }

  before do
    @pending_ticket = create(:pending_ticket, customer: customer)
    @ticket_with_comments = create(:ticket_with_comments, customer: customer)
    
    sign_in_as customer
  end

  scenario 'with ticket has no comments' do
    visit ticket_path(@pending_ticket)

    expect(page).to have_content("Comments disabled until a support agent comments")
  end

  scenario 'when ticket has comments' do
    visit ticket_path(@ticket_with_comments)

    expect(page).to have_content("Comments (#{@ticket_with_comments.comments_count})")
    
    expect(page).not_to have_content("Comments disabled until a support agent comments")
  end
end
