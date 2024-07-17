require 'minitest/autorun'
require 'webrick'
require 'net/http'
require_relative "../lib/api_responser"
require 'active_model'
require 'active_record'
require 'erb'
class Person
  include ActiveModel::Model
  attr_accessor :id, :name
end

class TestController
  include ApiResponser
end

class TestApiResponser < Minitest::Test
  PORT = 8888

  def setup
    @testController = TestController.new
  end

  def test_start
    server = http_server

    sleep 1
    requests = [
      { method: "GET",title: "blank item [show]", path: '/item', expected_body: '{"status":"success","code":200,"message":"Show","records":null,"records_count":0}', expected_status:200 },
      { method: "GET",title: "multiple items [index]", path: '/items', expected_body: '{"status":"success","code":200,"message":"List","records":[],"records_count":0}', expected_status:200 },
      { method: "POST",title: "create item", path: '/create_item', expected_body: "", expected_status:201 },
      { method: "POST",title: "update item", path: '/update_item', expected_body: nil, expected_status:204 },
      { method: "POST",title: "delete item", path: '/delete_item', expected_body: nil, expected_status:204 },
      { method: "GET",title: "exist item [show]", path: '/show_exists_item', expected_body: '{"status":"success","code":200,"message":"Show","records":{"id":1,"name":"Test Name"},"records_count":1}', expected_status:200 },
      { method: "GET",title: "multiple exist items [index]", path: '/show_exists_items', expected_body: '{"status":"success","code":200,"message":"List","records":[{"id":1,"name":"Test Name 1"},{"id":2,"name":"Test Name 2"}],"records_count":2}', expected_status:200 },
      { method: "POST",title: "can't create item", path: '/can_t_create_item', expected_body: nil, expected_status:422 },
      { method: "POST",title: "can't update item", path: '/can_t_update_item', expected_body: nil, expected_status:422 },
      { method: "POST",title: "can't delete item", path: '/can_t_delete_item', expected_body: nil, expected_status:500 },

    ]
    puts "Checking GET / POST / PUT methods"
    requests.each do |req|
      sleep 0.1
      response = make_request(req[:path], req[:method])
      if req[:expected_body].nil?
        assert_nil req[:expected_body], response.body
      else
        assert_equal req[:expected_body], response.body
      end
      assert_equal req[:expected_status], response.code.to_i
    end

    # Shutdown the server
    server.shutdown
  end

  private

  def http_server
    server = WEBrick::HTTPServer.new(Port: PORT)
    server.mount '/', Routes
    trap 'INT' do server.shutdown end
    Thread.new { server.start }
    server
  end

  def make_request(path, method = "GET")
    uri = URI("http://localhost:#{PORT}#{path}")
    case method
    when "GET"
      Net::HTTP.get_response(uri)
    when "POST"
      Net::HTTP.post_form(uri, {:id => 1, :name => "test"})
    end
  end
end

class Routes < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    controller = TestController.new
    response.content_type = "application/json"
    resp = { json: { error: "Not found" }.to_json, status: 404 }

    case request.path
    when '/create_item'
      resp = controller.record_created
    when '/update_item'
      resp = controller.record_updated
    when '/delete_item'
      resp = controller.record_deleted

    when '/can_t_create_item'
      resp = controller.record_not_created("Can't create item. Name should present", "column 'name' should exists")
    when '/can_t_update_item'
      resp = controller.record_not_updated("Can't update item. Name cannot be blank", "column 'name' should exists")
    when '/can_t_delete_item'
      resp = controller.record_not_deleted("Can't delete item.  Not permitted", "Action not permitted for user id='123'")

    else
      response.body = {error: "Invalid path"}.to_json
    end
    response.body = resp[:json]
    response.status = resp[:status]
  end

  def do_GET(request, response)
    controller = TestController.new
    response.content_type = "application/json"
    resp = { json: { error: "Not found" }.to_json, status: 404 }

    case request.path
    when '/item'
      resp = controller.record_show(nil)
    when '/items'
      resp = controller.record_index([])
    when '/show_exists_item'
      resp = controller.record_show(Person.new(:id => 1, :name => "Test Name"))
    when '/show_exists_items'
      resp = controller.record_index([Person.new(:id => 1, :name => "Test Name 1"), Person.new(:id => 2, :name => "Test Name 2")])
    when '/item_not_found'
      resp = controller.record_not_found()
    else
      response.body = {error: "Invalid path"}.to_json
    end
    response.body = resp[:json]
    response.status = resp[:status]
  end
end
