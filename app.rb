# frozen_string_literal: true

require 'roda'

require_relative './system/boot'

# The main class for Roda Application.
class App < Roda
  # Adds support for handling different execution environments (development/test/production).
  plugin :environments

  # Adds support for heartbeats.
  plugin :heartbeat

  configure :development, :production do
    # A powerful logger for Roda with a few tricks up it's sleeve.
    plugin :enhanced_logger
  end

  # The symbol_matchers plugin allows you do define custom regexps to use for specific symbols.
  plugin :symbol_matchers

  # Adds ability to automatically handle errors raised by the application.
  plugin :error_handler do |e|
    if e.instance_of?(Exceptions::InvalidParamsError)
      error_object    = e.object
      response.status = 422
    elsif e.instance_of?(Sequel::ValidationFailed)
      error_object    = e.model.errors
      response.status = 422
    else
      error_object    = { error: I18n.t('something_went_wrong') }
      response.status = 500
    end

    response.write(error_object.to_json)
  end

  # Allows modifying the default headers for responses.
  plugin :default_headers,
         'Content-Type' => 'application/json',
         'Strict-Transport-Security' => 'max-age=16070400;',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  # Adds request routing methods for all http verbs.
  plugin :all_verbs

  # The json_parser plugin parses request bodies in JSON format if the request's content type specifies JSON.
  # This is mostly designed for use with JSON API sites.
  plugin :json_parser

  route do |r|
    r.on('api') do
      r.on('v1') do
        r.post('sign_up') do
          sign_up_params = SignUpParams.new.permit!(r.params)
          user           = Users::Creator.new(attributes: sign_up_params).call
          tokens         = AuthorizationTokensGenerator.new(user: user).call

          UserSerializer.new(user: user, tokens: tokens).render
        end
      end
    end
  end
end
