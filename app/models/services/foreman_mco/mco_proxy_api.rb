class ForemanMco::McoProxyApi < ::ProxyAPI::Resource
  def initialize args
    @url     = args[:url] + "/mcollective"
    super args
  end

  def test
    parse(resource["test/test_command"].post(:name => "blah", 'params' => {:filters => filters}))
  end

  def install_package(package_name, filters)
    parse(resource["packages/#{package_name}"].post({}, 'params' => {:filters => filters}))
  end

  def uninstall_package(package_name, filters)
    parse(resource["packages/#{package_name}"].delete('params' => {:filters => filters}))
  end

  def service_status(service_name, filters)
    parse(resource[ "services/#{service_name}"].get('params' => {:filters => filters}))
  end

  def start_service(service_name, filters)
    parse(resource["services/#{service_name}/start"].post({}, 'params' => {:filters => filters}))
  end

  def stop_service(service_name, filters)
    parse(resource["services/#{service_name}/stop"].post({}, 'params' => {:filters => filters}))
  end

  def ping
    parse(resource["ping"].get('params' => {:filters => filters}))
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