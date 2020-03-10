# Q-HELPDESK

Q-HelpDesk is a simple application, built on the Ruby_on_Rails framework, that allows customers get the help they need from support agents.

## System Dependencies
#### Ruby version
This application uses Ruby 2.6.3 and Rails 6.

  

#### Other dependencies

NOTE:  This assumes you have a machine runing on the Mac OS and use Homebrew to manage dependencies.

Most of the dependencies for this app are included in the gemfile. However, other dependencies which must be installed first, cannot be installed through the Rails Bundler. To help make it easier to install, they have been listed in a BrewFile

First run `brew bundle` to let Homebrew install them. This would install the following dependencies:

-  `openssl@1.1`

-  `mysql` - database used for this project

-  `ruby-build`

-  `rbenv` - A ruby version manager

-  `yarn` - A package manager for NodeJS

-  `wkhtmltopdf` - For generating PDF files from HTML


Next, install Ruby 2.6.3 on which this project runs

-  `rbenv install ruby 2.6.3`

  
Install NodeJS through the downloaded installer or

- `brew install node`

to let Homebrew install the latest version.

  

Next, install bundler

- `gem install bundler`

  
Install the gems specified in the `Gemfile`, necessary to let the application run properly

- `bundle install`

  
If bundler has issues installing mysql, run

- `gem install mysql2 -- --with-ldflags=-L/usr/local/opt/openssl/lib`

and proceed to bundle install again.

  
Rails 6 uses Webpacker which leverages some NodeJS dependencies to make the front-end development more seamless. Use Yarn to install the necessary dependencies

- `yarn install`

  

## Configuration

For the app to run properly on your machine, you need some environment variables set. Create a file `/config/application.yml` and in it, add the names of your local database for development and test environments, like this:

 
```
DEVELOPMENT_DATABASE: q_helpdesk_development
TEST_DATABASE: q_helpdesk_test
```


## Database creation

To create the database, run

-  `rails db:create`

 
## Database initialization

To run migration, 

-  `rails db:migrate`

Some seed data have been included. Since factorybot was used for testing, fixtures are not included. It is important you seed the database, as an admin user has been included, and can only be seeded (you can't sign up as admin).

To seed the database, run

-  `rails db:seed`

To add more seed data, edit `/db/seeds.rb`

To run server,

-  `rails s`


To run tests,

-  `rails spec`

  

## THE DEVELOPMENT PROCESS

### A) Implemented features
The features implemented are
- Visitors to the Help Desk portal can create customer accounts with `email` and `password`. Basic Authentication is implemented with Rails sessions.
- Users with accounts can sign in to the application. There are three categories of users - `customers` who need some sort of help, `support agents` who listen to customer feedback and try to render assistance and `admin` users - on role to rule them all. Along with doing everything agents can do, admin users have special priviledges.
- Customers can create new tickets. Tickets fall in 3 categories - `pending`, `processing` , and `closed`.
- Customers can see a list of their created tickets and view them individually to see more details like comments.
- Customers can add comments to their tickets but ONLY IF an agent (or admin) has commented already.
- Agents (and admins) can see a list of tickets, with different options like viewing all tickets, only pending tickets, only processing, all closed tickets or tickets that have been closed in the last two months.
- Agents (and admins) can view the details of a ticket, and change its status. They also have no limitations when it comes to adding comments.
- Agents and admins can choose to export current table data as `CSV` or `PDF` for future analysis.
- Admins have a special dashboard which only them can access, where they can see a list of customers and agents. While here, they can make customers agents or revoke such powers from existing agents. While this is still barebones, it makes sense to be able to add new agents this way, because we do not have a feature that allows users to be invited by email, and sign up as agents with a special link. While developing this project, I though of adding a temporary or permanent ban feature
  

### B) Assumptions made while developing this project
- Admins are super agents. Admins can do everything agents can do, so they can fill in for them when them when the need arises. However, the admin user has a much improved view of the whole system. For example, when admins visit the tickets page, they are able to see on the table which agent was responsible for closing a ticket (this reflects in the PDF data generated). Agents do not have this privilege. Also, in the admin dashboard, an admin is able to see at a glance how many tickets have been closed by each agent.

- While faced with a choice of rendering the PDF export right away or sending it (so it downloads), I chose the latter. This is because it takes away the stress of trying to see how to download the rendered PDF. It also makes it easy to download different categories in quick succession.

-  I thought it made sense to name the PDF export based on the category of tickets exported and the day it was esported. This makes it easier to know what the eventual export file contains without having to open to check.
  

### C) Issues faced
- MySQL install. Since I had previously worked mostly with Postgres and MongoDB, I did not have MySQL installed on my current machine. While trying to set it up for the first time, it kept failing. On further research, I realized it had something to do with `open-ssl`. Reinstalling `open-ssl` fixed the issue.
- Generating PDF files. For some reason I did not know at the time, when I clicked export PDF, a file of about 1,776 pages would be rendered. On searching online, no one had the same issue. Had to settle down to re-read the WickedPDF documentation on GIthub and eventually saw what I missed. I had not properly specified the template to be used.
- Another blocker faced on this same export feature, was that the PDF files ignored my styling. Thanks to the docs, the workaround for this was to include bootstrap directly in the view file specified as the template.

### D) How this project can be improved
- The first thought that came to my mind when I saw the test specifications, was... "What if this was like a rails engine that can be integrated into existing systems?" However, that was too time-intensive a route to take. So perhaps this project I have developed can be made a whole lot more modular, so that it can be seamless integrated elsewhere.
- So I had a feature test I could not complete - testing the CSV and PDF downloads. While I would have found a way around it given more time, I definitely would look into that after this submission.
  

### E) How the assignment can be improved
I think the assignment was nice. Sufficiently challenging, and yet not insurmountable in a week. However, I think the specification document could use some proof-reading, as some typos made it somewhat more difficult to comprehend on first read. On the whole, it was perhaps the most exciting project I have done this year.

### Developed by
Oare Arene
