require "base64"
require "rest-client"

require "lead_router/version"


module LeadRouter

  def self.new(host, user, token)
    LeadRouter::Client.new(host, user, token)
  end

  class Client
    def initialize(host, user, token)
      @host = host
      @user = user
      @token = token
    end

    def create_lead(site_uuid, lead)
      RestClient::Request.execute(
        :method => :post,
        :url => "http://#{@host}/rest/sites/#{site_uuid}/leads",
        :payload => lead.to_json,
        :headers => {content_type: 'application/json', user_agent: "LeadRouterRuby/#{VERSION}"},
        :user => @user,
        :password => @token
      )
    end

    def update_lead(site_uuid, lead_uuid, lead)
      RestClient::Request.execute(
        :method => :patch,
        :url => "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}",
        :payload => lead.to_json,
        :headers => {content_type: 'application/json', user_agent: "LeadRouterRuby/#{VERSION}"},
        :user => @user,
        :password => @token
      )
    end

    def add_activities(site_uuid, lead_uuid, activities)
      RestClient::Request.execute(
        :method => :post,
        :url => "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}/activities",
        :payload => activities.to_json,
        :headers => {content_type: 'application/json', user_agent: "LeadRouterRuby/#{VERSION}"},
        :user => @user,
        :password => @token
      )
    end

    def create_potential_seller_lead(site_uuid, lead)
      RestClient::Request.execute(
        :method => :post,
        :url => "http://#{@host}/rest/sites/#{site_uuid}/potential-seller-leads",
        :payload => lead.to_json,
        :headers => {content_type: 'application/json', user_agent: "LeadRouterRuby/#{VERSION}"},
        :user => @user,
        :password => @token
      )
    end

  end

end
