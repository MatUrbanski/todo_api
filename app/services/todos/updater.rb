# frozen_string_literal: true

module Todos
  # {Todos::Updater} updates existing {Todo}.
  class Updater
    # @param [Todo] todo
    # @param [Hash] attributes of the {Todo}
    def initialize(todo:, attributes:)
      @todo       = todo
      @attributes = attributes
    end

    # It updates the existing {Todo} with new attributes.
    #
    # @return [Todo] object when attributes are valid.
    #
    # @raise [Sequel::ValidationFailed] when attributes are not valid.
    #
    # @example When attributes are valid:
    #   attributes = {name: 'Buy milk.', description: 'Please buy milk.'}
    #   Todos::Updater.new(todo: Todo.last, attributes: attributes).call
    #
    # @example When attributes are not valid:
    #   Todos::Updater.new(todo: Todo.last, attributes: {}).call
    def call
      @todo.update(
        name: @attributes[:name],
        description: @attributes[:description]
      )
    end
  end
end
