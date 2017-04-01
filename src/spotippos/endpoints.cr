require "./controllers/properties/index_action"
require "./controllers/properties/get_action"
require "./controllers/properties/create_action"

module Spotippos
  get "/properties" do |env|
    Controllers::Properties::IndexAction.new(env).call
  end

  get "/properties/:id" do |env|
    Controllers::Properties::GetAction.new(env).call
  end

  post "/properties" do |env|
    Controllers::Properties::CreateAction.new(env).call
  end
end
