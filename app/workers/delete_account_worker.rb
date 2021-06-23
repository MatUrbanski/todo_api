# frozen_string_literal: true

# {DeleteAccountWorker} is reponsible for deleting {User} account.
class DeleteAccountWorker
  include Sidekiq::Worker

  # It find and removes {User} account.
  #
  # @param [UUID] id of the user that we want to delete.
  #
  # @return [User] deleted {User} object.
  #
  # @example Synchronous delete:
  #   DeleteAccountWorker.new.perform('35a8916a-f998-4ac7-b7f1-8ed05385181a')
  #
  # @example Asynchronous delete:
  #   DeleteAccountWorker.perform_async('35a8916a-f998-4ac7-b7f1-8ed05385181a')
  def perform(id)
    User.with_pk!(id).delete
  end
end
