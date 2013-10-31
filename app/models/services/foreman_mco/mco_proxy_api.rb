class ForemanMco::McoProxyApi < ::ProxyAPI::Resource
  def initialize args
    @url     = args[:url] + "/mcollective"
    super args
  end

  def test
    parse(post({:name => "blah"}, "test/test_command"))
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