require "rest-client"

module LeadRouter

  class Client
    def initialize(host, user, token)
      @host = host
      @user = user
      @token = token
    end

    def create_lead(site_uuid, lead)
      require_arg "site_uuid", site_uuid
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/leads", lead.to_json
    end

    def update_lead(site_uuid, lead_uuid, lead)
      require_arg "site_uuid", site_uuid
      require_arg "lead_uuid", lead_uuid
      request :patch, "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}", lead.to_json
    end

    def add_activities(site_uuid, lead_uuid, activities)
      require_arg "site_uuid", site_uuid
      require_arg "lead_uuid", lead_uuid
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/leads/#{lead_uuid}/activities", activities.to_json
    end

    def create_potential_seller_lead(site_uuid, lead)
      require_arg "site_uuid", site_uuid
      request :post, "http://#{@host}/rest/sites/#{site_uuid}/potential-seller-leads", lead.to_json
    end

    # Send a request to update a user
    #
    # For now the lead manager is allowed to send this request, every other
    # client will get 403
    #
    # Must be called with the full user object, all fields. See all fields
    # in: https://developers.realgeeks.com/users/
    #
    # 'name' could be provided as 'first_name' and 'last_name', they will be
    # combined as 'name'
    def update_user(site_uuid, locutus_id, user)
      require_arg "site_uuid", site_uuid
      require_arg "locutus_id", locutus_id

      # if name not set try to use first_name and last_name
      user = user.clone
      first = user.delete(:first_name)
      last  = user.delete(:last_name)
      user['name'] ||= first unless first.nil?
      user['name'] += " #{last}" unless last.nil?

      request :put, "http://#{@host}/rest/sites/#{site_uuid}/users/#{locutus_id}", user.to_json
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
    rescue ::Exception => ex
      raise LeadRouter::Exception, ex
    end

    def require_arg(name, value)
      raise LeadRouter::Exception, ArgumentError.new("#{name} cannot be nil") if value.nil?
    end

  end
end
