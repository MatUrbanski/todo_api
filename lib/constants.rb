# frozen_string_literal: true

# {Constants} module is responsible for storing constants that are used across the application.
module Constants
  # Regex that is used during email validation process.
  EMAIL_REGEX = /^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/

  public_constant :EMAIL_REGEX

  # List of valid values for sort directions.
  SORT_DIRECTIONS = %w[desc asc].freeze

  public_constant :SORT_DIRECTIONS

  # List of columns that can be used for sorting to-dos ({Todo}).
  TODO_SORT_COLUMNS = %w[name description created_at updated_at].freeze

  public_constant :TODO_SORT_COLUMNS

  # Regex that is used during UUID validation process.
  UUID_REGEX = /(\h{8}(?:-\h{4}){3}-\h{12})/

  public_constant :UUID_REGEX
end
