# frozen_string_literal: true

require 'spec_helper'

describe MessageVerifier do
  let(:data)       { 'Test message' }
  let(:purpose)    { :test          }
  let(:expires_at) { Time.now + 60  }

  describe '.encode' do
    it 'encodes data' do
      expect(described_class.encode(data: data, purpose: purpose, expires_at: expires_at)).not_to eq data
    end
  end

  describe '.decode' do
    let(:message) { described_class.encode(data: data, expires_at: expires_at, purpose: purpose) }

    context 'when message is valid' do
      it 'decodes data from message' do
        expect(described_class.decode(message: message, purpose: purpose)).to eq data
      end
    end

    context 'when message is invalid' do
      it 'raise ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.decode(message: 'wrong message', purpose: purpose) }.to raise_error(
          ActiveSupport::MessageVerifier::InvalidSignature
        )
      end
    end

    context 'when message is expired' do
      let(:expires_at) { Time.now - 10 }

      let(:message) do
        described_class.encode(data: data, expires_at: expires_at, purpose: purpose)
      end

      it 'raise ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.decode(message: message, purpose: purpose) }.to raise_error(
          ActiveSupport::MessageVerifier::InvalidSignature
        )
      end
    end

    context 'when purpose is invalid' do
      it 'raise ActiveSupport::MessageVerifier::InvalidSignature' do
        expect { described_class.decode(message: message, purpose: :invalid) }.to raise_error(
          ActiveSupport::MessageVerifier::InvalidSignature
        )
      end
    end
  end
end
