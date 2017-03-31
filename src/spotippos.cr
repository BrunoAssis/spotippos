require "kemal"
require "./spotippos/version"
require "./spotippos/endpoints/*"
require "./spotippos/entities/*"
require "./spotippos/repositories/*"

before_all do |env|
  env.response.content_type = "application/json"
end

def handle_error(env)
  {"error" => env.get("error")}.to_json
end

error 400 { |env| handle_error(env) }
error 404 { |env| handle_error(env) }

Kemal.run
