

require 'minitest/autorun'
require 'webmock/minitest'

require 'lead_router'


class LeadRouterTest < Minitest::Test

  def test_create_lead
    stub_request(:any, /.*/)

    lr = LeadRouter.new("leadrouter.com", "LeadManager", "secret")
    lr.create_lead("site-123", {email: "lead@gmail.com"})

    assert_requested(:post, "http://LeadManager:secret@leadrouter.com/rest/sites/site-123/leads",
                     :headers => {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"},
                     :body => '{"email":"lead@gmail.com"}')
  end

  def test_update_lead
    stub_request(:any, /.*/)

    lr = LeadRouter.new("leadrouter.com", "LeadManager", "secret")
    lr.update_lead("site-123", "lead-abc", {email: "lead@gmail.com"})

    assert_requested(:patch, "http://LeadManager:secret@leadrouter.com/rest/sites/site-123/leads/lead-abc",
                     :headers => {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"},
                     :body => '{"email":"lead@gmail.com"}')
  end

  def test_add_activities
    stub_request(:any, /.*/)

    lr = LeadRouter.new("leadrouter.com", "LeadManager", "secret")
    lr.add_activities("site-123", "lead-abc", [{'type' => 'one'}, {'type' => 'two'}])

    assert_requested(:post, "http://LeadManager:secret@leadrouter.com/rest/sites/site-123/leads/lead-abc/activities",
                     :headers => {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"},
                     :body => '[{"type":"one"},{"type":"two"}]')
  end

  def test_add_potential_seller_lead
    stub_request(:any, /.*/)

    lr = LeadRouter.new("leadrouter.com", "LeadManager", "secret")
    lr.create_potential_seller_lead("site-123", {id: "abc"})

    assert_requested(:post, "http://LeadManager:secret@leadrouter.com/rest/sites/site-123/potential-seller-leads",
                     :headers => {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"},
                     :body => '{"id":"abc"}')
  end

end

