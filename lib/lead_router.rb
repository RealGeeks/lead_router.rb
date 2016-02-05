require "lead_router/version"
require "lead_router/client"
require "lead_router/exceptions"

module LeadRouter
  def self.new(host, user, token)
    LeadRouter::Client.new(host, user, token)
  end
end
