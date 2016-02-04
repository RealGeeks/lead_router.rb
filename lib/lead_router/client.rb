require "base64"
require "rest-client"

module LeadRouter

  class Client
    def initialize(host, user, token)
      @host = host
      @user = user
      @token = token
    end

    def create_lead(site_uuid, lead)
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/leads", lead.to_json
    end

    def update_lead(site_uuid, lead_uuid, lead)
      request :patch, "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}", lead.to_json
    end

    def add_activities(site_uuid, lead_uuid, activities)
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}/activities", activities.to_json
    end

    def create_potential_seller_lead(site_uuid, lead)
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/potential-seller-leads", lead.to_json
    end

    private

    def request(method, url, body)
      RestClient::Request.execute(
        :method => method,
        :url => url,
        :payload => body,
        :headers => {content_type: 'application/json', user_agent: "LeadRouterRuby/#{VERSION}"},
        :user => @user,
        :password => @token
      )
    end

  end
end
