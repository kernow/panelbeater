$:.unshift File.dirname(__FILE__)
require "test_helper"

class WhmTest < Test::Unit::TestCase
  
  def setup
    reset_webmock
    @expected_url = 'https://cpanel.server.local:2087/json-api/'
    @expected_auth_header = "WHM root:12345678"
    @connection = Panelbeater::Whm::Commands.new({ :url => 'cpanel.server.local', :api_key => "1234\r5678" })
  end
  
  
  context "404 error handling" do
    setup do
      stub_request(:get, "#{@expected_url}applist?").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:status => "404")
      @response = @connection.applist
    end

    should "return an error status" do
      assert_equal '404', @response.code
    end
  end
  
  context "returning a successful response" do
    setup do
      stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('createacct_success'))
      @response = @connection.createacct :username => 'amos'
    end

    should "return true" do
      assert @response.success?
    end
  end
  
  context "returning a unsuccessful response" do
    setup do
      stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('createacct_fail'))
      @response = @connection.createacct :username => 'amos'
    end

    should "return false" do
      assert !@response.success?
    end
  end
  
  context "running a request with key mappings" do
    setup do
      stub_request(:any, /.*/)
      @response = @connection.createacct({ :krazy => 'amos' }, { :krazy => :username })
    end

    should "send the request with the keys mapped correctly" do
      assert_requested :get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n",
        :headers => { 'Authorization' => @expected_auth_header }
    end
  end
  
  context "getting cpanel data from the cpanel response" do
    setup do
      stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
        with(:headers => { 'Authorization' => @expected_auth_header }).
        to_return(:body => fixture('createacct_success'))
      @response = @connection.createacct :username => 'amos'
    end

    should "return the status message" do
      assert_equal @response.statusmsg, 'Account Creation Ok'
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
    
    should "return the request was successful" do
      # there is no 'status' message returned with an applist request so success? should return false
      assert !@response.success?
    end
  end
  
  context "creating a new account" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('createacct_success'))
        @response = @connection.createacct :username => 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('createacct_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        assert_equal 'Account Creation Ok', @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}createacct?cpmod=x3&maxlst=0&hasshell=n&reseller=0&featurelist=default&ip=n&username=amos&cgi=y&frontpage=n").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('createacct_fail'))
        @response = @connection.createacct :username => 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('createacct_fail')), @response.json
      end

      should "return the request was successful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal "Sorry, that's an invalid domain\n", @response.statusmsg
      end
    end
  end
  
  context "changing a users package" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}changepackage?pkg=new_package&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('changepackage_success'))
        @response = @connection.changepackage 'amos', 'new_package'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('changepackage_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        assert_equal 'Account Upgrade/Downgrade Complete for sdflkhds', @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}changepackage?pkg=new_package&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('changepackage_fail'))
        @response = @connection.changepackage 'amos', 'new_package'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('changepackage_fail')), @response.json
      end

      should "return the request was successful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal 'Sorry you may not create any more accounts with the package one.', @response.statusmsg
      end
    end
  end
  
  context "changing a users password" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}passwd?user=bob&pass=hello").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('passwd_success'))
        @response = @connection.passwd('bob', 'hello')
      end

      should "return a list of commands" do
        assert_equal JSON.parse(fixture('passwd_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        assert_equal 'Password changed for user bob', @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}passwd?user=bob&pass=hello").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('passwd_fail'))
        @response = @connection.passwd('bob', 'hello')
      end

      should "return a list of commands" do
        assert_equal JSON.parse(fixture('passwd_fail')), @response.json
      end

      should "return the request was successful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal 'Sorry, the user bob2 does not exist.', @response.statusmsg
      end
    end
  end
  
  context "suspending a users account" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}suspendacct?reason=non%20payment%20of%20bill&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('suspendacct_success'))
        @response = @connection.suspendacct 'amos', 'non payment of bill'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('suspendacct_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        # yes the WHM API really does return this kind of crap as the status message
        assert_equal "<script>if (self['clear_ui_status']) { clear_ui_status(); }</script>\nChanging Shell to /bin/false...Changing shell for sdflkhds.\nWarning: \"/bin/false\" is not listed in /etc/shells\nShell changed.\nDone\nLocking Password...Locking password for user sdflkhds.\npasswd: Success\nDone\nSuspending mysql users\nNotification => tom@krystal.co.uk via EMAIL [level => 3]\nUsing Quota v3 Support\nSuspended document root /home/sdflkhds/public_html\nUsing Quota v3 Support\nSuspending FTP accounts...\nUpdating ftp passwords for sdflkhds\nFtp password files updated.\nFtp vhost passwords synced\nsdflkhds's account has been suspended\n", @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}suspendacct?reason=non%20payment%20of%20bill&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('suspendacct_fail'))
        @response = @connection.suspendacct 'amos', 'non payment of bill'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('suspendacct_fail')), @response.json
      end

      should "return the request was unsuccessful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal "_suspendacct called for a user that does not exist. (bobbie)", @response.statusmsg
      end
    end
    
  end

  context "unsuspending a users account" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}unsuspendacct?user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('unsuspendacct_success'))
        @response = @connection.unsuspendacct 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('unsuspendacct_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        assert_equal "<script>if (self['clear_ui_status']) { clear_ui_status(); }</script>\nChanging shell for sdflkhds.\nShell changed.\nUnlocking password for user sdflkhds.\npasswd: Success.\nUnsuspending FTP accounts...\nUpdating ftp passwords for sdflkhds\nFtp password files updated.\nFtp vhost passwords synced\nsdflkhds's account is now active\nUnsuspending mysql users\nNotification => tom@krystal.co.uk via EMAIL [level => 3]\n", @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}unsuspendacct?user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('unsuspendacct_fail'))
        @response = @connection.unsuspendacct 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('unsuspendacct_fail')), @response.json
      end

      should "return the request was unsuccessful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal "_unsuspendacct called for a user that does not exist. (bobbie)", @response.statusmsg
      end
    end
    
  end
  
  context "removing a users account" do
    
    context "successfully" do
      setup do
        stub_request(:get, "#{@expected_url}removeacct?keepdns=0&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('removeacct_success'))
        @response = @connection.removeacct 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('removeacct_success')), @response.json
      end

      should "return the request was successful" do
        assert @response.success?
      end

      should "return the status message" do
        assert_equal "amos account removed", @response.statusmsg
      end
    end
    
    context "unsuccessfully" do
      setup do
        stub_request(:get, "#{@expected_url}removeacct?keepdns=0&user=amos").
          with(:headers => { 'Authorization' => @expected_auth_header }).
          to_return(:body => fixture('removeacct_fail'))
        @response = @connection.removeacct 'amos'
      end

      should "return the json object" do
        assert_equal JSON.parse(fixture('removeacct_fail')), @response.json
      end

      should "return the request was unsuccessful" do
        assert !@response.success?
      end

      should "return the status message" do
        assert_equal "Warning!.. system user amos does not exist!\n", @response.statusmsg
      end
    end
  end
  
end