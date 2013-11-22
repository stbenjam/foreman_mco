module ForemanMco::Command
  class Base
    include ::ActiveModel::Validations
    attr_reader :filters

    def initialize(attrs = {})
      @filters = attrs[:filters] || []
    end

    def execute
      response = remote_call
      ::ForemanMco::CommandStatus.create!(:command => self.to_s, :jid => response)
    end

    def mco_proxy
      return @mco_proxy if @mco_proxy

      db_proxy_record = SmartProxy.joins(:features).where("features.name" => "MCollective").first
      raise ::Foreman::Exception.new(N_("There are no configured mcollective proxies")) unless db_proxy_record

      @mco_proxy = ForemanMco::McoProxyApi.new(:url => db_proxy_record.url)
    end
  end
end
