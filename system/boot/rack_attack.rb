# frozen_string_literal: true

# This file contains configuration for rack-attack.

Application.boot(:rack_attack) do
  init do
    require 'rack/attack'
  end

  start do |app|
    # Configure Redis cache.
    Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisStoreProxy.new(app[:redis])

    # Throttle POST requests to /api/v1/login by IP address.
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}".
    #
    # The most common brute-force login attack is a brute-force password
    # attack where an attacker simply tries a large number of emails and
    # passwords to see if any credentials match.
    #
    # Another common method of attack is to use a swarm of computers with
    # different IPs to try brute-forcing a password for a specific account.
    Rack::Attack.throttle('/logins/ip', limit: 10, period: 60) do |req|
      req.ip if req.path == '/api/v1/login' && req.post?
    end

    # Throttle POST requests to /api/v1/login by email param.
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{normalized_email}".
    #
    # This creates a problem where a malicious user could intentionally
    # throttle logins for another user and force their login requests to be
    # denied, but that's not very common and shouldn't happen to you.
    Rack::Attack.throttle('/logins/email', limit: 10, period: 60) do |req|
      if req.path == '/api/v1/login' && req.post? && req.params['email']
        req.params['email'].to_s.downcase.gsub(/\s+/, '').presence
      end
    end

    # Throttle POST requests to /api/v1/sign_up by IP address.
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:sign_up/ip:#{req.ip}".
    #
    # During an attack, the hackers bots will typically sign up with a random email then do something bad,
    # hundreds of times a minute, from a relatively small number of computers.
    # The judicious use of endpoint-based request restriction can prevent your site from being an attractive
    # target for spammers and hackers. It can also reduce the size of any successful bot attack by
    # limiting the amount of possible signups.
    # In this example, hackers can only add up to three users every quarter of an hour
    Rack::Attack.throttle('sign_up/ip', limit: 3, period: 900) do |req|
      req.ip if req.path == '/api/v1/sign_up' && req.post?
    end

    # Throttle all requests by IP (60rpm).
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}".
    #
    # If any single client IP is making tons of requests, then they're
    # probably malicious or a poorly-configured scraper. Either way, they
    # don't deserve to hog all of the app server's CPU. Cut them off!
    Rack::Attack.throttle('req/ip', limit: 20, period: 20, &:ip)

    # Allow all requests from localhost.
    Rack::Attack.safelist('allow from localhost') do |req|
      req.ip == '127.0.0.1' || req.ip == '::1'
    end
  end
end
