# Ruby client to Real Geeks Leads API

Send leads and activities to Lead Router, the Real Geeks Leads API.

For more details see [our documentation](http://docs.realgeeks.com/outgoing_leads_api_developers).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lead_router'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lead_router

## Usage

First get a user and token from the `lead_router` project, it will identify your project and which permissions you have.

If you're a Real Geeks client send a message to [support](https://www.realgeeks.com/support/) and we'll give you credentials.

```ruby
require 'lead_router'

lr = LeadRouter.new("receivers.leadrouter.realgeeks.com", "user", "token")
```

with a client created use one the methods below. For details on which fields
you can send for a `lead` or an `activity`, see our [API docs](http://docs.realgeeks.com/incoming_leads_api)

#### `create_lead(site_uuid, lead)`

Send a new lead.

 - `site_uuid` is a string with the RG2 Site UUID
 - `lead` id a dictionary with lead fields

#### `update_lead(site_uuid, lead_uuid, lead)`

Update an existing lead.

 - `site_uuid` is a string with the RG2 Site UUID
 - `lead_uuid` is a string with the Lead Manager Lead UUID
 - `lead` id a dictionary with lead fields to be overriden

#### `add_activities(site_uuid, lead_uuid, activities)`

Add activities to an existing lead.

 - `site_uuid` is a string with the RG2 Site UUID
 - `lead_uuid` is a string with the Lead Manager Lead UUID
 - `activities` is a list of dictionaries, each dictionary is an activitity

#### `create_potential_seller_lead(site_uuid, lead)`

Send a new potential seller lead.  Somebody who attempted to view a property valuation but didn't sign-up to give contact details. So all we have is the property they looked at.

 - `site_uuid` is a string with the RG2 Site UUID
 - `lead` id a dictionary with lead fields

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
