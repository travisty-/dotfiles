local node_name = (...):parse()["node.name"]

SimpleEventHook({
  name = "custom/switch-to-element-iii",
  interests = {
    EventInterest({
      Constraint({ "event.type", "=", "node-added" }),
      Constraint({ "node.name", "=", node_name, type = "pw" }),
    }),
  },
  execute = function(event)
    local om = event:get_source():call("get-object-manager", "metadata")
    local metadata = om:lookup({ Constraint({ "metadata.name", "=", "default" }) })
    if metadata then
      metadata:set(0, "default.configured.audio.sink", "Spa:String:JSON", Json.Object({ name = node_name }):to_string())
    end
  end,
}):register()
