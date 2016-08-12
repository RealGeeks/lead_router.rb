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

    def update_user(site_uuid, locutus_id, user)
      require_arg "site_uuid", site_uuid
      require_arg "locutus_id", locutus_id
      # build name via first/last_name
      first = user.delete(:first_name)
      last  = user.delete(:last_name)

      # but always use name param if given
      user['name'] ||= "#{first} #{last}" unless first.nil? || last.nil?

      request :patch, "http://#{@host}/rest/sites/#{site_uuid}/users/#{locutus_id}", user.to_json
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
