$:.unshift File.dirname(__FILE__)
require "test_helper"

class WhmTest < Test::Unit::TestCase
  
  def setup
    FakeWeb.clean_registry
    @expected_url = 'https://cpanel.server.local:2087/json-api/'
    @connection = CpanelApi::Whm::Commands.new({ :url => 'cpanel.server.local', :api_key => '1234' })
  end
  
  
  context "404 error handling" do
    setup do
      FakeWeb.register_uri(:get, "#{@expected_url}applist?", :body => '', :status => ["404", "Not Found"])
      @response = @connection.applist
    end

    should "return an error status" do
      assert_equal 'Not Found', @response.message
      assert_equal '404', @response.code
    end
  end
  
  
  
  context "getting a list of commands the server supports" do
    setup do
      FakeWeb.register_uri(:get, "#{@expected_url}applist?", :body => fixture('applist'))
      @response = @connection.applist
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('applist')), @response.json
    end
  end
  
  
  context "creating a new account" do
    setup do
      FakeWeb.register_uri  :get,
      "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n",
                            :body => fixture('createacct_success')
      @response = @connection.createacct :username => 'amos'
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('createacct_success')), @response.json
    end
  end
  
  
  context "creating a new account with key mappings" do
    setup do
      FakeWeb.register_uri  :get,
      "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n",
                            :body => fixture('createacct_success')
      @response = @connection.createacct({ :krazy => 'amos' }, { :krazy => :username })
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('createacct_success')), @response.json
    end
  end
  
  
  context "changing a users password" do
    setup do
      FakeWeb.register_uri  :get,
      "#{@expected_url}passwd?user=bob&pass=hello",
                            :body => fixture('passwd_success')
      @response = @connection.passwd('bob', 'hello')
    end

    should "return a list of commands" do
      assert_equal JSON.parse(fixture('passwd_success')), @response.json
    end
  end

end