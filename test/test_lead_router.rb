require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/mini_test'

require 'lead_router'


class LeadRouterTest < Minitest::Test

  #
  # Make sure all public api methods call 'request' private method correctly
  #

  def test_create_lead
    lr = LeadRouter.new("api.com", "LM", "secret")
    lr.expects(:request).with(:post, 'http://api.com/rest/sites/site-123/leads',
                              '{"email":"lead@gmail.com"}')

    lr.create_lead("site-123", {email: "lead@gmail.com"})
  end

  def test_update_lead
    lr = LeadRouter.new("api.com", "LM", "secret")
    lr.expects(:request).with(:patch,  "http://api.com/rest/sites/site-123/leads/lead-abc",
                             '{"email":"lead@gmail.com"}')

    lr.update_lead("site-123", "lead-abc", {email: "lead@gmail.com"})
  end

  def test_add_activities
    lr = LeadRouter.new("api.com", "LM", "secret")
    lr.expects(:request).with(:post, "http://api.com/rest/sites/site-123/leads/lead-abc/activities",
                              '[{"type":"one"},{"type":"two"}]')

    lr.add_activities("site-123", "lead-abc", [{'type' => 'one'}, {'type' => 'two'}])
  end

  def test_add_potential_seller_lead
    lr = LeadRouter.new("api.com", "LM", "secret")
    lr.expects(:request).with(:post, "http://api.com/rest/sites/site-123/potential-seller-leads",
                              '{"id":"abc"}')

    lr.create_potential_seller_lead("site-123", {id: "abc"})
  end

  #
  # Test 'request' method
  #

  def test_request
    stub_request(:any, /.*/)

    lr = LeadRouter.new("leadrouter.com", "LM", "secret")
    lr.send(:request, :post, "http://api.com/leads", '{"id":"123"}')

    assert_request_performed(:post, "http://LM:secret@api.com/leads", '{"id":"123"}')
  end

  #
  # Custom asserts
  #

  private

  def assert_request_performed(method, url, body)
    assert_requested(method, url,
                     :body => body,
                     :headers => {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"})
  end

end

