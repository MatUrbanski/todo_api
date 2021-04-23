# frozen_string_literal: true

# {Todo} model stores information about {User} todos.
#
# @!attribute id
#   @return [UUID] ID of the {Todo} in UUID format.
#
# @!attribute name
#   @return [String] Name of the {Todo}.
#
# @!attribute description
#   @return [String] Description of the {Todo}.
#
# @!attribute user_id
#   @return [UUID] ID of the {User} which {Todo} belongs to in UUID format.
#
# @!attribute created_at
#   @return [DateTime] Time when {Todo} was created.
#
# @!attribute updated_at
#   @return [DateTime] Time when {Todo} was updated.
class Todo < Sequel::Model
  many_to_one :user

  dataset_module do
    # It filters todos by their name.
    #
    # @param [String] name of the {Todo} or its part.
    #
    # @return [Array<Todo>] Array of {Todo} objects.
    #
    # @example Search Todo by name:
    #   Todo.search_by_name('milk')
    def search_by_name(name)
      where(Sequel.ilike(:name, "%#{name}%"))
    end

    # It filters todos by their description.
    #
    # @param [String] description of the {Todo} or its part.
    #
    # @return [Array<Todo>] Array of {Todo} objects.
    #
    # @example Search Todo by description:
    #   Todo.search_by_description('buy milk')
    def search_by_description(description)
      where(Sequel.ilike(:description, "%#{description}%"))
    end
  end
end
