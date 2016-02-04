require "lead_router/version"
require "lead_router/client"

module LeadRouter
  def self.new(host, user, token)
    LeadRouter::Client.new(host, user, token)
  end
end
