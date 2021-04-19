# frozen_string_literal: true

# This file contains configuration to let the webserver which application to run.

require_relative 'app'

run App.freeze.app
