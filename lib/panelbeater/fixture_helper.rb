module Panelbeater
  class FixtureHelper
    
    def self.load(name)
      File.read( File.join(File.dirname(__FILE__),"../../test/fixtures", "#{name}.json") )
    end
    
  end
end
