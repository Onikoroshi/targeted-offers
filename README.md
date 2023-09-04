# README

* Ruby version
2.7.5

* Rails version
7.0.7

* System dependencies
  * postgresql version 14
  * node.js version v16.14.0
  * npm version 8.3.1
  * yarn version 1.22.19
  * react version 18

* Configuration
  * `bundle install`
  * `yarn install`

* Database creation
  * `rails db:create`

* Database initialization
  * `rails db:rebuild`

* How to run the test suite
  * `rspec spec`

* How to start the server
  * `bin/dev`

## Explanation of Gender Decision

Gender is an important topic in today's marketing world. We might miss out on important demographics if we limit our system to just the traditional two genders, regardless of what our personal views on the subject might be. So, rather than use a simple true/false field or even a static enum, I made the decision to create an entire Gender table and attach both Users and Offers to it. Entries to that table can be added by the developer initially, or an admin page can be created to expand the options. Offers can have many genders so that the advertisers can cast their nets as wide or as tight as they wish (ie, the Offer can match both Females and Gay Males, if appropriate). In addition, both our advertisers and our users might wish to define even more genders, so both Users and Offers have a "custom_gender" field where they can give us a value they'd like made into an "official" gender option. This field could be used by our system administrator to identify popular gender terms that would then be added to the official list. Future features could make that process easier and faster. Additionally, the system could use the values in those fields to perform more "fuzzy" matching of Users to Offers than afforded by the official list. In short, this allows the application the flexibility needed to adapt to today's ever fluctuating marketing world.
