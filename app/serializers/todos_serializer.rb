# frozen_string_literal: true

# {TodosSerializer} is responsible for representing multiple todos ({Todo}) in JSON format.
#
# @example Represent multiple todos {Todo} in the JSON format:
#   TodosSerializer.new(todo: Todo.all).render
class TodosSerializer < ApplicationSerializer
  # It generates Hash object with multiple todos ({Todo}) details.
  #
  # @return [Hash] object with multiple todos ({Todo}) details.
  def to_json
    {
      todos: todos
    }
  end

  private

  # It returns array of todos ({Todo}).
  #
  # @return [Array<>Hash] todos ({Todo}) data.
  def todos
    @todos.map do |todo|
      TodoSerializer.new(todo: todo).to_json
    end
  end
end
