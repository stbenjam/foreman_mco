class ForemanMco::McoProxyApi < ::ProxyAPI::Resource
  def initialize args
    @url     = args[:url] + "/mcollective"
    super args
  end

  def test
    parse(post({:name => "blah"}, "test/test_command"))
  end

  def install_package(package_name)
    parse(post({}, "packages/#{package_name}"))
  end

  def uninstall_package(package_name)
    parse(delete({}, "packages/#{package_name}"))
  end

  def service_status(service_name)
    parse(get("services/#{service_name}"))
  end

  def start_service(service_name)
    parse(post({}, "services/#{service_name}/start"))
  end

  def stop_service(service_name)
    parse(post({}, "services/#{servcie_name}/stop"))
  end

  def ping
    parse(get("ping"))
  end

  def parse(response)
      if response and response.code >= 200 and response.code < 300
        response.body.present? ? (JSON.parse(response.body) rescue response.body) : true
      else
        false
      end
    rescue => e
      logger.warn "Failed to parse response: #{response} -> #{e}"
      false
  end
end