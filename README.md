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


### Developed by
Oare Arene
