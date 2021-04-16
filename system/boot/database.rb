# frozen_string_literal: true

# This file contain code to setup the database connection.

Application.boot(:database) do |container|
  # Load environment variables before setting up database connection.
  use :environment_variables

  init do
    require 'sequel/core'
  end

  start do
    # Delete DATABASE_URL from the environment, so it isn't accidently passed to subprocesses.
    database = Sequel.connect(ENV.delete('DATABASE_URL'))

    # Register database component.
    container.register(:database, database)
  end
end
