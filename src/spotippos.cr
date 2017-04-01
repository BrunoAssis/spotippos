require "kemal"

require "./spotippos/version"
require "./spotippos/endpoints"

before_all do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

def respond_with_error(env, status_code, error_message)
  env.response.status_code = status_code
  env.response.print({"error" => error_message}.to_json)
  env.response.close
end

require "../fixtures/load_fixtures"
Fixtures.load_fixtures unless ENV["KEMAL_ENV"]? == "test"

Kemal.run
