require 'fcg-service-clients/models/session'

module FCG
  module Models
    class Session
      include FCG::Client::Session
      setup_service :hydra => FCG::Client::Base::HYDRA, :host => FCG_CONFIG.app.service_url, :version => FCG_CONFIG.app.service_version
    end
  end
end
