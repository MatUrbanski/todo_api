# frozen_string_literal: true

# {TodoSerializer} is responsible for representing single todo ({Todo}) in JSON format.
#
# @example Represent {Todo} in the JSON format:
#   TodoSerializer.new(todo: Todo.last).render
class TodoSerializer < ApplicationSerializer
  # It generates Hash object with single todo ({Todo}) details.
  #
  # @return [Hash] object with single todo ({Todo}) details.
  #
  # @example Prepare data before transformation to the JSON format:
  #   TodoSerializer.new(todo: Todo.last).to_json
  def to_json
    {
      id: @todo.id,
      name: @todo.name,
      description: @todo.description,
      created_at: @todo.created_at,
      updated_at: @todo.updated_at
    }
  end
end
