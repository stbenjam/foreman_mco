module ForemanMco::Command
  class InstallPackage < Base
    include ::ActiveModel::Validations

    attr_reader :package_name
    validates :package_name, :presence => true

    def initialize(attrs)
      @package_name = attrs[:package_name]
    end

    def invoke
      mco_proxy.test
    end

    def to_s
      "package install #{package_name}"
    end
  end
end