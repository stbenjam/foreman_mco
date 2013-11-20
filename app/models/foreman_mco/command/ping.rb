module ForemanMco::Command
  class Ping < Base    
    def command
      {:command => :ping}
    end

    def to_s
      "ping"
    end
  end
end
