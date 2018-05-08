E2VguiCore.RegisterVguiElementType("dcombobox.lua",true)

local function isValidDComboBox(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

//register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcombobox",function(uniqueID,parentPnlID)
	local tbl = {
		//this table has no impact whatsoever because it doesn't get called on the client
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dcombobox",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = nil,
		["height"] = nil,
		["text"] = "DComboBox",
		["visible"] = true,
		["choice"] = nil,
		["clear"] = nil
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dcombobox", "xcb", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return !isValidDComboBox(v)
	end
)

E2VguiCore.RegisterTypeWithID("dcombobox","xcb")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xcb", "xcb", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xcb pnldata)
	return isValidDComboBox(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xcb pnldata)
	return isValidDComboBox(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xcb ldata, xcb rdata)
	if !isValidDComboBox(ldata) then return 0 end
	if !isValidDComboBox(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xcb ldata, n index)
	if !isValidDComboBox(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xcb rdata)
	if !isValidDComboBox(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xcb ldata, xcb rdata)
	if !isValidDComboBox(ldata) then return 1 end
	if !isValidDComboBox(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xcb ldata, n index)
	if !isValidDComboBox(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xcb rdata)
	if !isValidDComboBox(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dcombobox element
	Args:
	Return: dcombobox
---------------------------------------------------------------------------]]


e2function dcombobox dcombobox(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcombobox",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dcombobox dcombobox(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcombobox",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dcombobox:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dcombobox:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dcombobox:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dcombobox:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dcombobox:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dcombobox:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	--------------------------------choices--------------------------------
	e2function void dcombobox:addChoice(string displayText,string data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,number data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,vector2 data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,vector data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,vector4 data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,array data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
	end

	e2function void dcombobox:addChoice(string displayText,table data)
		E2VguiCore.registerAttributeChange(this,"choice", {displayText,E2VguiCore.convertToLuaTable(data)})
	end
	--------------------------------choices--------------------------------

	e2function void dcombobox:clear()
		E2VguiCore.registerAttributeChange(this,"clear", true)
	end

	e2function void dcombobox:setValue(string text)
		E2VguiCore.registerAttributeChange(this,"value", text)
	end

	e2function void dcombobox:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
	end

	e2function void dcombobox:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dcombobox:getPos()
		return {this["paneldata"]["posX"] or 0,this["paneldata"]["posY"] or 0}
	end

	e2function vector2 dcombobox:getSize()
		return {this["paneldata"]["width"] or 0,this["paneldata"]["height"] or 0}
	end

	e2function number dcombobox:getWidth()
		return this["paneldata"]["width"] or 0
	end

	e2function number dcombobox:getHeight()
		return this["paneldata"]["height"] or 0
	end

	e2function string dcombobox:getValue()
		return this["paneldata"]["value"] or ""
	end

	e2function number dcombobox:isVisible()
		return this["paneldata"]["visible"] and 1 or 0
	end
-- getter
end

do--[[utility]]--
	e2function void dcombobox:create()
		E2VguiCore.CreatePanel(self,this)
	end

	--TODO: make it update it child panels when the parent is modified ?
	e2function void dcombobox:modify()
		E2VguiCore.ModifyPanel(self,this)
	end

	e2function void dcombobox:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcombobox:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcombobox:addPlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			//check for redundant players will be done in CreatePanel or ModifyPanel
			//maybe change that ?
			table.insert(this["players"],ply)
		end
	end

	e2function void dcombobox:removePlayer(entity ply)
		for k,v in pairs(this["players"]) do
			if ply == v then
				table.remove(this["players"],k)
			end
		end
	end
-- utility
end