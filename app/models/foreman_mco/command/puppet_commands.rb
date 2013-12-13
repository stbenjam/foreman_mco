module ForemanMco::Command
  class PuppetRunOnce < Base
    def remote_call
      mco_proxy.puppet_runonce(filters)
    end

    def to_s
      "puppet runonce"
    end
  end

  class PuppetEnable < Base
    def remote_call
      mco_proxy.puppet_enable(filters)
    end

    def to_s
      "puppet start"
    end
  end

  class PuppetDisable < Base
    def remote_call
      mco_proxy.puppet_disable(filters)
    end

    def to_s
      "puppet stop"
    end
  end
end
