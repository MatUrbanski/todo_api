# frozen_string_literal: true

# {MessageVerifier} makes it easy to generate and verify messages which are signed to prevent tampering.
# @see https://api.rubyonrails.org/v6.0.3.4/classes/ActiveSupport/MessageVerifier.html ActiveSupport::MessageVerifier Documentation
class MessageVerifier
  class << self
    # It encode data using ActiveSupport::MessageVerifier.
    #
    # @param [Hash, Array, String] data that will be encoded.
    # @param [Integer] expires_at in seconds telling when the message expires.
    # @param [Symbol] purpose that describes how the message will be used.
    #
    # @return [String] signed message for the provided value.
    #
    # @example Encode a message:
    #   MessageVerifier.encode(data: 'secret', expires_at: Time.now + 360, purpose: :test)
    def encode(data:, expires_at:, purpose:)
      verifier.generate(data, expires_at: expires_at, purpose: purpose)
    end

    # It decodes data using ActiveSupport::MessageVerifier
    #
    # @param [String] message that will be used in decoding process.
    # @param [Symbol] purpose that describes how the message will be used.
    #
    # @return [Hash, Array, String] data that has been decoded.
    #
    # @raise [ActiveSupport::MessageVerifier::InvalidSignature] when message is invalid.
    #
    # @example Decode a valid message:
    #   message = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ3R6WldOeVpYU"
    #   MessageVerifier.decode(message: message, purpose: :test)
    #
    # @example Decode invalid message:
    #   MessageVerifier.decode(message: 'invalid-message', purpose: :test)
    def decode(message:, purpose:)
      verifier.verify(message, purpose: purpose)
    end

    private

    # It returns instance of ActiveSupport::MessageVerifier.
    #
    # @return [ActiveSupport::MessageVerifier] instance of ActiveSupport::MessageVerifier.
    def verifier
      ActiveSupport::MessageVerifier.new(ENV['SECRET_KEY_BASE'], digest: 'SHA512')
    end
  end
end
