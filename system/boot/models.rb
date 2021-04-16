# frozen_string_literal: true

# This file contains configuration for Sequel Models.

Application.boot(:models) do
  init do
    require 'sequel/model'
  end

  start do
    # Whether association metadata should be cached in the association reflection.
    # If not cached, it will be computed on demand.
    # In general you only want to set this to false when using code reloading.
    # When using code reloading, setting this will make sure that if an associated class is removed or modified,
    # this class will not have a reference to the previous class.
    Sequel::Model.cache_associations = false if Application.env == 'development'

    # The validation_helpers plugin contains validate_* methods designed to be called inside Model#validate to perform validations.
    Sequel::Model.plugin(:auto_validations)

    # The validation_helpers plugin contains validate_* methods designed to be called inside Model#validate to perform validations.
    Sequel::Model.plugin(:validation_helpers)

    # The prepared_statements plugin modifies the model to use prepared statements for instance level inserts and updates.
    Sequel::Model.plugin(:prepared_statements)

    # Allows easy access all model subclasses and descendent classes.
    Sequel::Model.plugin(:subclasses) unless Application.env == 'development'

    # Creates hooks for automatically setting create and update timestamps.
    Sequel::Model.plugin(:timestamps)

    # Allows you to use named timezones instead of just :local and :utc (requires TZInfo).
    Sequel.extension(:named_timezones)

    # Use UTC time zone for saving time inside database.
    Sequel.default_timezone = :utc

    # Freeze all descendent classes. This also finalizes the associations for those classes before freezing.
    Sequel::Model.freeze_descendents unless Application.env == 'development'
  end
end
