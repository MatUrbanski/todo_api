# frozen_string_literal: true

# {TodosParams} validates GET /api/v1/teachers params.
#
# @example When params are valid:
#   TodosParams.new.permit!(search_by_name: 'mat')
#
# @example When params are invalid:
#   TodosParams.new.permit!({direction: "invalid"})
class TodosParams < ApplicationParams
  # @!method params
  #   It stores rules for validating GET /api/v1/todos endpoint params using dry-validation DSL.
  params do
    optional(:search_by_name).value(:string)
    optional(:search_by_description).value(:string)
    optional(:sort).value(included_in?: Constants::TODO_SORT_COLUMNS)
    optional(:direction).value(included_in?: Constants::SORT_DIRECTIONS)
  end
end
