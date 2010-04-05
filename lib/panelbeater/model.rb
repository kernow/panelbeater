module Panelbeater
  module Model
    
    def key_mappings(map, hash)
      map.each_key do |k|
        if hash.has_key? k
          hash[map[k]] = hash[k]
          hash.delete(k)
        end
      end
      hash
    end

    def filter_options(hash)
      hash.each do |k,v|
        if v == true
          hash[k] = 1
        elsif v == false
          hash[k] = 0
        end
      end
      hash.delete_if {|k,v| v.nil? }
    end
    
  end
end