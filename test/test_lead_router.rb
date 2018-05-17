require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/mini_test'

require 'lead_router'


class LeadRouterTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:client) { LeadRouter.new("api.com", "LM", "secret") }

  #
  # Make sure all public api methods call 'request' private method correctly
  #

  def test_create_lead
    client.expects(:request).with(:post, 'https://api.com/rest/sites/site-123/leads',
                                  '{"email":"lead@gmail.com"}', nil)

    client.create_lead("site-123", {email: "lead@gmail.com"})
  end

  def test_create_lead_manual_destination
    client.expects(:request).with(:post, 'https://api.com/rest/sites/site-123/leads',
                                  '{"email":"lead@gmail.com"}',
                                  {"X-ROUTER-DESTINATIONS" => "wibble"})

    client.create_lead("site-123", {email: "lead@gmail.com"}, ["wibble"])
  end

  def test_create_lead_for_multiple_destination
    client.expects(:request).with(:post, 'https://api.com/rest/sites/site-123/leads',
                                  '{"email":"lead@gmail.com"}',
                                  {"X-ROUTER-DESTINATIONS" => "wibble,wobble"})

    client.create_lead("site-123", {email: "lead@gmail.com"}, ["wibble", "wobble"])
  end

  def test_update_lead
    client.expects(:request).with(:patch,  "https://api.com/rest/sites/site-123/leads/lead-abc",
                                  '{"email":"lead@gmail.com"}')

    client.update_lead("site-123", "lead-abc", {email: "lead@gmail.com"})
  end

  def test_update_user
    client.expects(:request).with(:put, "https://api.com/rest/sites/site-123/users/1234",
                                  '{"name":"Kat","email":"kat@mail.com"}')

    client.update_user("site-123", "1234", {name: "Kat", email: "kat@mail.com"})
  end

  def test_update_user_combines_name_from_first_and_last_names
    client.expects(:request).with(:put, "https://api.com/rest/sites/site-123/users/1234",
                                  '{"email":"bob@mail.com","name":"Bob Saget"}')

    client.update_user("site-123", "1234", {first_name: "Bob", last_name: "Saget", email: "bob@mail.com"})
  end

  def test_update_user_uses_first_name_even_if_last_name_not_provided
    client.expects(:request).with(:put, "https://api.com/rest/sites/site-123/users/1234",
                                  '{"email":"bob@mail.com","name":"Bob"}')

    client.update_user("site-123", "1234", {first_name: "Bob", email: "bob@mail.com"})
  end

  def test_update_user_dont_modify_hash_provided
    user = {first_name: "Kat", email: "kat@mail.com"}
    client.expects(:request).with(:put, "https://api.com/rest/sites/site-123/users/1234",
                                  '{"email":"kat@mail.com","name":"Kat"}')

    client.update_user("site-123", "1234", user)

    assert_equal({first_name: "Kat", email: "kat@mail.com"}, user)
  end

  def test_delete_user
    client.expects(:request).with(:delete, "http://api.com/rest/sites/site-123/users/1234")

    client.delete_user("site-123", "1234")
  end

  def test_add_activities
    client.expects(:request).with(:post, "https://api.com/rest/sites/site-123/leads/lead-abc/activities",
                                  '[{"type":"one"},{"type":"two"}]')

    client.add_activities("site-123", "lead-abc", [{'type' => 'one'}, {'type' => 'two'}])
  end

  def test_add_potential_seller_lead
    client.expects(:request).with(:post, "https://api.com/rest/sites/site-123/potential-seller-leads",
                                  '{"id":"abc"}')

    client.create_potential_seller_lead("site-123", {id: "abc"})
  end

  def test_required_arguments
    # make sure I have a nice error message if caller gives me nil for required arguments
    client.stubs(:request)

    tests = [
      ["site_uuid cannot be nil", Proc.new { client.create_lead(nil, {}) }],
      ["site_uuid cannot be nil", Proc.new { client.update_lead(nil, "lead-abc", {}) }],
      ["lead_uuid cannot be nil", Proc.new { client.update_lead("site-123", nil, {}) }],
      ["site_uuid cannot be nil", Proc.new { client.create_potential_seller_lead(nil, {}) }],
      ["site_uuid cannot be nil", Proc.new { client.add_activities(nil, "lead-abc", []) }],
      ["site_uuid cannot be nil", Proc.new { client.update_user(nil, 1234, {}) }],
      ["lead_uuid cannot be nil", Proc.new { client.add_activities("site-123", nil, []) }],
      ["user_id cannot be nil",   Proc.new { client.update_user("site-123", nil, {}) }],
    ]

    tests.each do |error_message, test|
      ex = assert_raises(LeadRouter::Exception) { test.call }
      assert_equal error_message, ex.to_s
    end
  end

  #
  # Test 'request' method
  #

  def test_request
    stub_request(:any, /.*/)

    client.send(:request, :post, "https://api.com/leads", '{"id":"123"}')

    assert_requested(:post, "https://LM:secret@api.com/leads", body: '{"id":"123"}', headers: headers)
  end

  def test_request_empty_body
    stub_request(:any, /.*/)

    client.send(:request, :delete, "https://api.com/users/123")

    assert_requested(:delete, "https://LM:secret@api.com/users/123", headers: headers)
  end

  def test_request_invalid_status_code
    stub_request(:any, /.*/).to_return(status: 401, body: '{"error":"unauthorized"}')

    ex = assert_raises LeadRouter::Exception do
      client.send(:request, :post, "https://api.com/leads", '{"id":"123"}')
    end

    assert_equal 401, ex.http_code
    assert_equal '{"error":"unauthorized"}', ex.http_body
  end

  def test_request_other_exceptions
    RestClient::Request.stubs(:execute).raises(RuntimeError.new("something bad"))

    ex = assert_raises LeadRouter::Exception do
      client.send(:request, :post, "https://api.com/leads", '{"id":"123"}')
    end

    assert_equal 0, ex.http_code
    assert_equal "", ex.http_body
  end

  private

  def headers
    {'Content-Type'=>'application/json', 'User-Agent'=>"LeadRouterRuby/#{LeadRouter::VERSION}"}
  end

end

