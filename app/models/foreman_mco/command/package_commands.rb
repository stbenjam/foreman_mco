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
    def command
      {:command => :install_package, :args => @package_name}
    end

    def to_s
      "package install #{package_name}"
    end
  end

  class UninstallPackage < BasePackage
    def command
      {:command => :uninstall_package, :args => @package_name}
    end

    def to_s
      "package uninstall #{package_name}"
    end
  end
end
