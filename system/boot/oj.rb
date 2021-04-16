# frozen_string_literal: true

# This file contains configuration for oj gem.

Application.boot(:oj) do
  init do
    require 'oj'
  end

  start do
    # :compat attempts to extract variable values from an Object using
    # to_json() or to_hash() then it walks the Object's variables if neither is found.
    Oj.default_options = { mode: :compat }
  end
end
