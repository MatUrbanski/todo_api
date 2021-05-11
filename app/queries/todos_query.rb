# frozen_string_literal: true

# {TodosQuery} class is responsible for filtering todos ({Todo}).
class TodosQuery
  # @param [Todo] dataset to process.
  # @param [Hash] params with attributes to filter.
  def initialize(dataset:, params:)
    @dataset = dataset
    @params  = params
  end

  # It filters todos ({Todo}) based on the provided params.
  #
  # @return [Array<Todo>] Array of {Todo} objects.
  #
  # @example Find {Todo} by name:
  #   TodosQuery.new(dataset: Todo, params: {search_by_name: 'milk'}).call
  #
  # @example Find {Todo} by description:
  #   TodosQuery.new(dataset: Todo, params: {search_by_description: 'buy milk'}).call
  #
  # @example Find {Todo} by multiple attributes:
  #   TodosQuery.new(dataset: Todo, params: {search_by_name: 'milk', search_by_description: 'buy milk'}).call
  #
  # @example Order todos ({Todo}) by name in ascending order:
  #   TodosQuery.new(dataset: Todo, params: {sort: 'name', direction: 'asc'}).call
  def call
    scoped = @dataset
    scoped = scoped.search_by_name(@params[:search_by_name]) if @params[:search_by_name]
    scoped = scoped.search_by_description(@params[:search_by_description]) if @params[:search_by_description]
    scoped = scoped.order(Sequel.public_send(direction, sort))

    scoped.all
  end

  private

  # It returns sort order.
  #
  # @return [Symbol] Sort order.
  def sort
    (@params[:sort] || :created_at).to_sym
  end

  # It returns sort direction.
  #
  # @return [Symbol] Sort direction.
  def direction
    @params[:direction] || :desc
  end
end
