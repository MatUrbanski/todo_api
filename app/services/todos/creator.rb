# frozen_string_literal: true

module Todos
  # {Todos::Creator} creates {Todo} for specified {User}.
  class Creator
    # @param [User] user that newly created Todo will belong to.
    # @param [Hash] attributes of the {Todo}.
    def initialize(user:, attributes:)
      @user       = user
      @attributes = attributes
    end

    # It creates {Todo} object for specified {User} based on the passed attributes.
    #
    # @return [Todo] object when attributes are valid.
    #
    # @raise [Sequel::ValidationFailed] when attributes are not valid
    #
    # @example When attributes are valid:
    #   attributes = {name: 'Buy milk.', description: 'Please buy milk.'}
    #   Todos::Creator.new(user: User.last, attributes: attributes).call
    #
    # @example When attributes are not valid:
    #   Todos::Creator.new(user: User.last, attributes: {}).call
    def call
      Todo.create(
        user: @user,
        name: @attributes[:name],
        description: @attributes[:description]
      )
    end
  end
end
