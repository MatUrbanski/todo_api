# frozen_string_literal: true

Sequel.migration do
  up do
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      CREATE EXTENSION IF NOT EXISTS "citext";
    SQL
  end

  down do
    execute <<-SQL
      DROP EXTENSION IF EXISTS "uuid-ossp";
      DROP EXTENSION IF EXISTS "citext";
    SQL
  end
end
