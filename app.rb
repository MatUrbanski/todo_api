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

  # Validate UUID format.
  symbol_matcher :uuid, Constants::UUID_REGEX

  # Adds ability to automatically handle errors raised by the application.
  plugin :error_handler do |e|
    if e.instance_of?(Exceptions::InvalidParamsError)
      error_object    = e.object
      response.status = 422
    elsif e.instance_of?(Sequel::ValidationFailed)
      error_object    = e.model.errors
      response.status = 422
    elsif e.instance_of?(Exceptions::InvalidEmailOrPassword)
      error_object    = { error: I18n.t('invalid_email_or_password') }
      response.status = 401
    elsif e.instance_of?(ActiveSupport::MessageVerifier::InvalidSignature)
      error_object    = { error: I18n.t('invalid_authorization_token') }
      response.status = 401
    elsif e.instance_of?(Sequel::NoMatchingRow)
      error_object    = { error: I18n.t('not_found') }
      response.status = 404
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

  # It validates authorization token that was passed in Authorization header.
  #
  # @see AuthorizationTokenValidator
  def current_user
    return @current_user if @current_user

    purpose = request.url.include?('refresh_token') ? :refresh_token : :access_token

    @current_user = AuthorizationTokenValidator.new(
      authorization_token: env['HTTP_AUTHORIZATION'],
      purpose: purpose
    ).call
  end

  route do |r|
    r.on('api') do
      r.on('v1') do
        r.post('sign_up') do
          sign_up_params = SignUpParams.new.permit!(r.params)
          user           = Users::Creator.new(attributes: sign_up_params).call
          tokens         = AuthorizationTokensGenerator.new(user: user).call

          UserSerializer.new(user: user, tokens: tokens).render
        end

        r.post('login') do
          login_params = LoginParams.new.permit!(r.params)
          user         = Users::Authenticator.new(email: login_params[:email], password: login_params[:password]).call
          tokens       = AuthorizationTokensGenerator.new(user: user).call

          UserSerializer.new(user: user, tokens: tokens).render
        end

        r.delete('logout') do
          Users::UpdateAuthenticationToken.new(user: current_user).call

          response.write(nil)
        end

        r.post('refresh_token') do
          Users::UpdateAuthenticationToken.new(user: current_user).call

          tokens = AuthorizationTokensGenerator.new(user: current_user).call

          TokensSerializer.new(tokens: tokens).render
        end

        r.delete('delete_account') do
          DeleteAccountWorker.perform_async(current_user.id)

          response.write(nil)
        end

        r.on('todos') do
          # We are calling the current_user method to get the current user
          # from the authorization token that was passed in the Authorization header.
          current_user

          r.on(:uuid) do |id|
            todo = current_user.todos_dataset.with_pk!(id)

            r.get do
              TodoSerializer.new(todo: todo).render
            end

            r.put do
              todo_params = TodoParams.new.permit!(r.params)

              Todos::Updater.new(todo: todo, attributes: todo_params).call

              TodoSerializer.new(todo: todo).render
            end

            r.delete do
              todo.delete

              response.write(nil)
            end
          end

          r.get do
            todos_params = TodosParams.new.permit!(r.params)
            todos        = TodosQuery.new(dataset: current_user.todos_dataset, params: todos_params).call

            TodosSerializer.new(todos: todos).render
          end

          r.post do
            todo_params = TodoParams.new.permit!(r.params)
            todo        = Todos::Creator.new(user: current_user, attributes: todo_params).call

            TodoSerializer.new(todo: todo).render
          end
        end
      end
    end
  end
end
