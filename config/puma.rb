# frozen_string_literal: true

# This file contains puma web server configuration.

# Puma forks multiple OS processes within each dyno to allow a Rails app to support multiple concurrent requests.
# In Puma terminology, these are referred to as worker processes
# (not to be confused with Heroku worker processes which run in their dynos).
# Worker processes are isolated from one another at the OS level, therefore not needing to be thread-safe
workers Integer(ENV['WEB_CONCURRENCY'] || 1)

# Puma can serve each request in a thread from an internal thread pool.
# This behavior allows Puma to provide additional concurrency for your web application.
# Loosely speaking, workers consume more RAM and threads consume more CPU, and both offer more concurrency.
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

# Preloading your application reduces the startup time of individual Puma worker processes and
# allows you to manage the external connections of each worker using the on_worker_boot calls.
# In the config above, these calls are used to establish Postgres connections for each worker process correctly.
preload_app!

# Heroku will set ENV['PORT'] when the web process boots up. Locally, default this to 3000 to match the Rails default.
port ENV['PORT'] || 3000

# Set the environment of Puma. On Heroku ENV['RACK_ENV'] will be set to 'production' by default.
environment ENV['RACK_ENV'] || 'development'

# *Cluster mode only* Code to run immediately before master process forks workers (once on boot).
# These hooks can block if necessary to wait for
# background operations unknown to puma to finish before the process terminates.
# This can be used to close any connections to remote servers (database, redis)
# that were opened when preloading the code.
# This can be called multiple times to add hooks.
before_fork do
  Sequel::Model.db.disconnect if defined?(Sequel::Model)
end
