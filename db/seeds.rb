# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([
  { 
    email: 'admin@example.com',
    password: 'mypassword',
    admin: true,
    created_at: 13.days.ago,
    updated_at: 13.days.ago
  },
  { 
    email: 'agent@example.com',
    password: 'mypassword',
    support_agent: true,
    created_at: 10.days.ago,
    updated_at: 9.days.ago,
  },
  {
    email: 'customer@example.com',
    password: 'mypassword',
    created_at: 8.days.ago,
    updated_at: 8.days.ago,
  },
])

tickets = Ticket.create([
  {
    title: 'first ticket',
    description: "This is my first ticket. I had to open it because...",
    customer: users.last,
    closed: true,
    closed_at: DateTime.current,
    closed_by: users.second,
    created_at: 8.days.ago,
    updated_at: 4.days.ago,
  },
  { title: 'Me again',
    description: "Need help with something else",
    customer: users.last,
    processing: true,
    process_start_at: DateTime.current,
    created_at: 5.days.ago,
    updated_at: 5.days.ago,
  },
  {
    title: 'Another ticket',
    description: "I thought this was fixed!!!",
    customer: users.last,
    created_at: 2.days.ago,
    updated_at: 2.days.ago,
  },
])

comments = Comment.create([
  {
    body: "What help do you need?",
    ticket: tickets.first,
    user: users.second,
    created_at: 8.days.ago,
    updated_at: 8.days.ago,
  },
  {
    body: "Having issues with 2FA",
    ticket: tickets.first,
    user: users.last,
    created_at: 7.days.ago,
    updated_at: 7.days.ago,
    edited: true,
  },
  {
    body: "Check your mail for steps to fix this",
    ticket: tickets.first,
    user: users.second,
    created_at: 7.days.ago,
    updated_at: 7.days.ago,
  },
  {
    body: "Great,thanks!",
    ticket: tickets.first,
    user: users.last,
    created_at: 6.days.ago,
    updated_at: 6.days.ago,
  },
  {
    body: "You're welcome. In the absence of other related issues, I would be closing this ticket",
    ticket: tickets.first,
    user: users.second,
    created_at: 5.days.ago,
    updated_at: 5.days.ago,
  },
])
