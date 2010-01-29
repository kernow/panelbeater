$:.unshift File.dirname(__FILE__)
require "test_helper"

class WhmTest < Test::Unit::TestCase
  
  def setup
    @expected_url = 'https://cpanel.server.local:2087/json-api/'
    @expected_auth_header = "WHM root:12345678"
    @connection = CpanelApi::Whm::Commands.new({ :url => 'cpanel.server.local', :api_key => "1234\r5678" })
  end
  
  
  context "404 error handling" do
    setup do
      stub_request(:get, "#{@expected_url}applist?").with(:headers => { 'Authorization' => @expected_auth_header }).to_return(:status => "404")
      @response = @connection.applist
    end

    should "return an error status" do
      assert_equal '404', @response.code
    end
  end
  
  
  
  context "getting a list of commands the server supports" do
    setup do
      stub_request(:get, "#{@expected_url}applist?").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('applist'))
      @response = @connection.applist
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('applist')), @response.json
    end
  end
  
  
  context "creating a new account" do
    setup do
      stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('createacct_success'))
      @response = @connection.createacct :username => 'amos'
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('createacct_success')), @response.json
    end
  end
  
  
  context "creating a new account with key mappings" do
    setup do
      stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('createacct_success'))
      @response = @connection.createacct({ :krazy => 'amos' }, { :krazy => :username })
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('createacct_success')), @response.json
    end
  end
  
  
  context "changing a users password" do
    setup do
      stub_request(:get, "#{@expected_url}passwd?user=bob&pass=hello").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('passwd_success'))
      @response = @connection.passwd('bob', 'hello')
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('passwd_success')), @response.json
    end
  end

end