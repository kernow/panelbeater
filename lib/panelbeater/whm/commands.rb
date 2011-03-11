module Panelbeater
  module Whm
    class Commands
      include Model
      include Remote
      include Cpanel
    
      attr_accessor :base_url
      attr_accessor :user
      attr_accessor :api_key
      attr_accessor :port
    
      def initialize(options={})
        @log = Logger.new(STDOUT)
        @log.level = Logger::INFO
        set_server(options)
      end
  
      # Each WHM API command has its own method
    
      # Get a users account summary
      def accountsummary(user)
        do_request 'accountsummary', {:user => user}
      end
  
  
      # Add a new package
      #
      # required params:
      # name
      # quota
      # maxftp
      # maxsql
      # maxpop
      # maxlists
      # maxsub
      # maxpark
      # maxaddon
      # bwlimit
  
      def addpkg(options={}, mappings=nil)
        default_options = { :featurelist => 'default',
                            :ip => 0,
                            :cgi => 1,
                            :frontpage => 0,
                            :cpmod => 'x3',
                            :hasshell => 0 }
        all_options = default_options.merge!(options)
        do_request 'addpkg', all_options, mappings
      end
  
      # Returns a list of available commands
      def applist
        do_request 'applist'
      end
    
      # Change a users package
      def changepackage(user, package)
        do_request 'changepackage', {:user => user, :pkg => package}
      end
    
      # Call cpanel API1 and API2 commands
      #
      # user (string)
      # The name of the user that owns the cPanel account to be affected.
      # xmlin (XML)
      # XML container for the function. Format <cpanelaction><module><func><args></args></func></module></cpanelaction>
      # module (string)
      # Name of the module to access. (See http://www.cpanel.net/plugins/api2/index.html for module and function names)
      # apiversion (integer)
      # Version of the API to access. (1 = API1, no input defaults to API2)
      # func (string)
      # Name of the function to access. (See http://www.cpanel.net/plugins/api2/index.html for module and function names)
      # args (XML or string)
      # List of arguments or argument container. See examples for API1 and API2 passing arguments.
    
      def cpanel(user, options={})
        default_options = { :apiversion => 2 }
        all_options = default_options.merge!(options).merge!(:user => user)
        do_request 'cpanel', all_options
      end
    
      # Create a new account
      #
      # username (string)
      # User name of the account. Ex: user
      # domain (string)
      # Domain name. Ex: domain.tld
      # plan (string)
      # Package to use for account creation. Ex: reseller_gold
      # quota (integer)
      # Disk space quota in MB. (0-999999, 0 is unlimited)
      # password (string)
      # Password to access cPanel. Ex: p@ss!w0rd$123
      # ip (string)
      # Whether or not the domain has a dedicated IP address. (y = Yes, n = No)
      # cgi (string)
      # Whether or not the domain has cgi access. (y = Yes, n = No)
      # frontpage (string)
      # Whether or not the domain has FrontPage extensions installed. (y = Yes, n = No)
      # hasshell (string)
      # Whether or not the domain has shell / ssh access. (y = Yes, n = No)
      # contactemail (string)
      # Contact email address for the account. Ex: user@otherdomain.tld
      # cpmod (string)
      # cPanel theme name. Ex: x3
      # maxftp (string)
      # Maximum number of FTP accounts the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxsql (string)
      # Maximum number of SQL databases the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxpop (string)
      # Maximum number of email accounts the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxlst (string)
      # Maximum number of mailing lists the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxsub (string)
      # Maximum number of subdomains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxpark (string)
      # Maximum number of parked domains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # maxaddon (string)
      # Maximum number of addon domains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
      # bwlimit (string)
      # Bandiwdth limit in MB. (0-999999, 0 is unlimited)
      # customip (string)
      # Specific IP address for the site.
      # useregns (boolean)
      # Use the registered nameservers for the domain instead of the ones configured on the server. (1 = Yes, 0 = No)
      # hasuseregns (boolean)
      # Set to 1 if you are using the above option.
      # reseller (boolean)
      # Give reseller privileges to the account. (1 = Yes, 0 = No)
  
      def createacct(options={}, mappings=nil)
        default_options = { :featurelist => 'default',
                            :ip => 'n',
                            :cgi => 'y',
                            :frontpage => 'n',
                            :cpmod => 'x3',
                            :hasshell => 'n',
                            :maxlst => 0,
                            :reseller => 0 }
        all_options = default_options.merge!(options)
        do_request 'createacct', all_options, mappings
      end
    
      # Edits an existing package
      #
      # name (string)
      # Name of the package.
      # featurelist (string)
      # Name of the feature list to be used for the package.
      # quota (integer)
      # Disk space quota for the package (in MB). (max is unlimited)
      # ip (boolean)
      # Whether or not the account has a dedicated IP. Yes=1, No=0.
      # cgi (boolean)
      # Whether or not the account has cgi access. Yes=1, No=0.
      # frontpage (boolean)
      # Whether or not the account can install FrontPage extensions. Yes=1, No=0.
      # cpmod (string)
      # What to change the default package them to. Format: cpmod=themename
      # maxftp (integer)
      # The maximum amount of FTP accounts a user assigned to the package can create. (max is 999)
      # maxsql (integer)
      # The maximum amount of SQL databases a user assigned to the package can create. (max is 999)
      # maxpop (integer)
      # The maximum amount of email accounts a user assigned to the package can create. (max is 999)
      # maxlists (integer)
      # The maximum amount of email lists a user assigned to the package can create. (max is 999)
      # maxsub (integer)
      # The maximum amount of subdomains a user assigned to the package can create. (max is 999)
      # maxpark (integer)
      # The maximum amount of parked domains a user assigned to the package can create. (max is 999)
      # maxaddon (integer)
      # The maximum amount of addon domains a user assigned to the package can create. (max is 999)
      # hasshell (boolean)
      # Whether or not the account has shell access. Yes=1, No=0.
      # bwlimit (integer)
    
      def editpkg(name, options={}, mappings=nil)
        default_options = { :featurelist => 'default',
                            :ip => 'n',
                            :cgi => 'y',
                            :frontpage => 'n',
                            :cpmod => 'x3',
                            :hasshell => 'n',
                            :maxlists => '0' }
        all_options = default_options.merge!(options).merge!(:name => name)
        do_request 'editpkg', all_options, mappings
      end
  
      def fetchsslinfo
    
      end
  
      def generatessl
    
      end
    
      # Get the hostname of the server
      def gethostname
        do_request 'gethostname'
      end
  
      # List of available languages
      def getlanglist
        do_request 'getlanglist'
      end
    
      # Deletes a package from the server
      def killpkg(package)
        do_request 'killpkg', {:pkg => package}
      end
    
      # Searches for an account
      #
      # searchtype
      # Type of account search. (domain | owner | user | ip | package )
      # search
      # Search criteria. (Perl Regular Expression)
    
      def listaccts(term = nil, options={})
        if term.nil?
          # Lists all Accounts
          do_request 'listaccts'
        else
          # Lists accounts accorning to the search term
          default_options = {:searchtype => 'user'}
          all_options = default_options.merge!(options).merge!(:search => term)
          do_request 'listaccts', all_options
        end
      end
    
      # Reseller functionality not needed yet
      def listacls
    
      end
  
      def listcrts
    
      end
    
      # List packages on server
      def listpkgs
        do_request 'listpkgs'
      end
    
      # Reseller functionality not needed yet
      def listresellers
    
      end
    
      # List suspended accounts
      def listsuspended
        do_request 'listsuspended'
      end
    
      # Get the server load average
      def loadavg
        do_request 'loadavg'
      end
    
      # Change and accounts password
      def passwd(user, password)
        do_request 'passwd', {:user => user, :pass => password}
      end
    
      # Reboot the server, don't know if this works or if it takes any arguments
      def reboot
        do_request 'reboot'
      end
    
      # Remore and account from the server
      def removeacct(user, options={})
        default_options = {:keepdns => false}
        all_options = default_options.merge!(options).merge!(:user => user)
        do_request 'removeacct', all_options
      end
    
      # Reseller functionality not needed yet
      def resellerstats
    
      end
    
      # Restart a service on the server
      #
      # service
      # Service to restart (bind | interchange | ftp | httpd | imap | cppop | exim | mysql | postgres | ssh | tomcat)
    
      def restartservice(service)
        do_request 'restartservice', :service => service
      end
    
      # Reseller functionality not needed yet
      def saveacllist
    
      end
    
      # Reseller functionality not needed yet
      def setacls
    
      end
    
      # Reseller functionality not needed yet
      def setupreseller
    
      end
    
      # Get bandwidth usage for all users, don't know if this takes additional parameters
      def showbw
        do_request 'showbw'
      end
    
      # Suspend an account
      def suspendacct(user, reason)
        do_request 'suspendacct', {:user => user, :reason => reason}
      end
    
      # Reseller functionality not needed yet
      def terminatereseller
    
      end
    
      # Reseller functionality not needed yet
      def unsetupreseller
    
      end
    
      # Unsuspend an account
      def unsuspendacct(user)
        do_request 'unsuspendacct', :user => user
      end
    
      # Get the of WHM
      def version
        do_request 'version'
      end
    end
  end
end