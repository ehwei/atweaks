local db_details = CreateFrame("Frame", "at_DetailsToggle")
db_details.obj = LibStub("LibDataBroker-1.1"):NewDataObject("atDetails", {
    type = "data source",
    text = "|cffffd100Details|r",
    OnClick = function(button, down)
        Details:ToggleWindows()
    end
})
--
--
-- function db_details.obj.onClick()
-- Details:ReabrirTodasInstancias()
--
-- Details:ShutDownAllInstances()
