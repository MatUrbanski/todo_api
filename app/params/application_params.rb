# frozen_string_literal: true

# {ApplicationParams} is base class that contains configuration
# that is used across all params validator classes.
class ApplicationParams < Dry::Validation::Contract
  # It checks if passed params are valid base on params validation rules in child class.
  # If params are invalid {Exceptions::InvalidParamsError} is raised.
  # When params are valid it returns provided params.
  #
  # @param [Hash] params that've beeen passed to the endpoint.
  #
  # @return [Hash] Hash when provided params are valid.
  #
  # @raise [InvalidParamsError] {Exceptions::InvalidParamsError} when provided params are not valid.
  def permit!(params)
    params = self.class.new.call(params)

    raise(invalid_params_error(params)) if params.errors.any?

    params.to_h
  end

  private

  # It returns {Exceptions::InvalidParamsError} instance.
  #
  # @param [Hash] params with errors.
  #
  # @return [Exceptions::InvalidParamsError]
  def invalid_params_error(params)
    Exceptions::InvalidParamsError.new(params.errors.to_h, I18n.t('invalid_params'))
  end
end
