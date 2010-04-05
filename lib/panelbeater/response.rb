module Panelbeater
  class Response
    
    @@response_types = {
      :applist        => 'app',
      :createacct     => 'result',
      :changepackage  => 'result',
      :passwd         => 'passwd',
      :suspendacct    => 'result',
      :unsuspendacct  => 'result',
      :removeacct     => 'result'
    }
    
    def initialize(command, response)
      @command  = command
      @response = response
    end
    
    def success?
      self.status == 1
    end
    
    def code
      @response.code
    end
    
    def json
      JSON.parse @response.body
    end
    
    def method_missing(method, *args)
      # check for a key in the json response
      if json[node_name].respond_to? 'first'
        if json[node_name].first.respond_to?('has_key?') && json[node_name].first.has_key?(method.to_s)
          json[node_name].first[method.to_s]
        end
      end
    end
    
    private
    
      def node_name
        @node_name ||= @@response_types[@command.to_sym]
      end
    
  end
end