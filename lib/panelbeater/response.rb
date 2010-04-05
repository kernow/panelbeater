module CpanelApi
  class Response
    
    @@response_types = {
      :applist      => 'app',
      :createacct   => 'result',
      :passwd       => 'passwd'
    }
    
    def initialize(command, response)
      @command  = command
      @response = response
    end
    
    def success?
      json[node_name].first['status'] == 1
    end
    
    def code
      @response.code
    end
    
    def json
      JSON.parse @response.body
    end
    
    def method_missing(method, *args)
      # check for a key in the json response
      return(json[node_name].first[method.to_s]) if json[node_name].first.has_key?(method.to_s)
    end
    
    private
    
      def node_name
        @node_name ||= @@response_types[@command.to_sym]
      end
    
  end
end