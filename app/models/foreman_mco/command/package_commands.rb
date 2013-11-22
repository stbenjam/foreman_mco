module ForemanMco::Command
  class BasePackage < Base
    include ::ActiveModel::Validations

    attr_reader :package_name
    validates :package_name, :presence => true

    def initialize(attrs)
      super
      @package_name = attrs[:package_name]
    end
  end

  class InstallPackage < BasePackage
    def remote_call
      mco_proxy.install_package(@package_name, filters)
    end

    def to_s
      "package install #{package_name}"
    end
  end

  class UninstallPackage < BasePackage
    def remote_call
      mco_proxy.uninstall_package(@package_name, filters)
    end

    def to_s
      "package uninstall #{package_name}"
    end
  end
end
