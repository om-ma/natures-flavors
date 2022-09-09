CanonicalRails::TagHelper.module_eval do

  def path_without_sort_by
    return '' if request.path == '/'

    request.path.sub(/\/sort_by\/.*?(?=\/|$)/, '')
  end

  def canonical_href(host = canonical_host, port = canonical_port, force_trailing_slash = nil)
    default_ports = { 'https://' => 443, 'http://' => 80 }
    port = port.present? && port.to_i != default_ports[canonical_protocol] ? ":#{port}" : ''
    raw "#{canonical_protocol}#{host}#{port}#{path_without_sort_by}#{trailing_slash_config(force_trailing_slash)}#{allowed_query_string}"
  end

end
