module ForemanMco::Command
  class Ping < Base    
    def invoke
      mco_proxy.ping
    end

    def to_s
      "ping"
    end
  end
end
