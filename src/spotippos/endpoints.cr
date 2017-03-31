require "./controllers/properties/index_action"
require "./controllers/properties/get_action"
require "./controllers/properties/create_action"

module Spotippos
  index_action = Controllers::Properties::IndexAction.new
  get "/properties" do |env|
    index_action.call(env)
  end

  get_action = Controllers::Properties::GetAction.new
  get "/properties/:id" do |env|
    get_action.call(env)
  end

  create_action = Controllers::Properties::CreateAction.new
  post "/properties" do |env|
    create_action.call(env)
  end
end
