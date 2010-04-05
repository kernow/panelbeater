module Panelbeater
  module Cpanel
    module Commands
    
      def addsubdomain(user, subdomain, rootdomain, directory)
        cpanel(user, {:xmlin => "<cpanelaction><module>SubDomain</module><func>addsubdomain</func><args><domain>#{subdomain}</domain><rootdomain>#{rootdomain}</rootdomain><dir>#{directory}</dir></args></cpanelaction>"})
      end
    end
  end
end