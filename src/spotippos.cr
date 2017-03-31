require "kemal"
require "./spotippos/version"
require "./spotippos/endpoints/*"
require "./spotippos/entities/*"
require "./spotippos/repositories/*"

before_all do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

def respond_with_error(env, status_code, error_message)
  env.response.status_code = status_code
  env.response.print({"error" => error_message}.to_json)
  env.response.close
end

Kemal.run
