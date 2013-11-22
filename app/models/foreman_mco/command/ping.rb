module ForemanMco::Command
  class Ping < Base    
    def remote_call
      mco_proxy.ping(filters)
    end

    def to_s
      "ping"
    end
  end
end
