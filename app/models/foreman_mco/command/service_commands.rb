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
    def invoke
      mco_proxy.service_status(service_name)
    end

    def to_s
      "service status #{service_name}"
    end
  end

  class StartService < ServiceBase
    def invoke
      mco_proxy.start_service(service_name)
    end

    def to_s
      "service start #{service_name}"
    end
  end

  class StopService < ServiceBase
    def invoke
      mco_proxy.stop_service(service_name)
    end

    def to_s
      "service stop #{service_name}"
    end
  end
end
