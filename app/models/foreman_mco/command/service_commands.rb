module ForemanMco::Command
  class ServiceBase < Base
    include ::ActiveModel::Validations

    attr_reader :service_name
    validates :service_name, :presence => true

    def initialize(attrs)
      super
      @service_name = attrs[:service_name]
    end
  end

  class ServiceStatus < ServiceBase
    def remote_call
      mco_proxy.service_status(service_name, filters)
    end

    def to_s
      "service status #{service_name}"
    end
  end

  class StartService < ServiceBase
    def remote_call
      mco_proxy.start_service(service_name, filters)
    end

    def to_s
      "service start #{service_name}"
    end
  end

  class StopService < ServiceBase
    def remote_call
      mco_proxy.stop_service(service_name, filters)
    end

    def to_s
      "service stop #{service_name}"
    end
  end
end
