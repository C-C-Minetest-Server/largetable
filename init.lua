largertable = {}
local S = minetest.get_translator("largertable")
local gui = flow.widgets

local table_form = flow.make_gui(function(player,ctx)
	local pos = ctx.pos
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local benchsize = 4

	for x in ipairs({1,2,3,4,5,6}) do
		local upgrade = inv:get_stack("upgrades",x)
		local udef = minetest.registered_items[upgrade:get_name()]
		benchsize = benchsize + (udef and udef.groups and udef.largetable_upgrades or 0)
	end
	inv:set_size("crafting",benchsize * benchsize)

	return gui.VBox {
		gui.HBox {
			gui.List {
				inventory_location = "context",
				list_name = "upgrades",
				w = 2,
				h = 3,
			},
			gui.Spacer {},
			gui.List {
				inventory_location = "context",
				list_name = "crafting",
				w = benchsize,
				h = benchsize,
			},
			gui.List {
				inventory_location = "context",
				list_name = "result",
				w = 1,
				h = 1,
			}
		},
		gui.List {
			inventory_location = "current_player",
			list_name = "main",
			w = 8,
			h = 4,
		}
	}
end)

local function clear_craft(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_list("crafting",{})
end

local function get_formspec(pos,player)
	local ctx = {pos=pos}

	local name = player and player:get_player_name()
    local info = name and minetest.get_player_information(name)
    local tree, form_info = table_form:_render(player, ctx, info and info.formspec_version)

    local fs = assert(formspec_ast.unparse(tree))

    return fs
end

minetest.register_node("largetable:bench",{
	description = S("Large Crafting Table"),
	_doc_items_longdesc = S("Crafting table with more slots."),
	_doc_items_usagehelp = S("Rightclick the crafting table to open the formspec. Use table upgrades to enlarge it."),
	tiles = {},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("upgrades",6)
		inv:set_size("result",1)
		meta:set_string("formspec",get_formspec(pos))
		meta:set_string("infotext",S("Large Crafting Table"))
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "upgrades" then
			return 1
		elseif to_list == "crafting" then
			return count
		else
			return 0
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player),
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if to_list == "upgrades" then
			local orig_count = inv:get_stack("upgrades",index):get_count()
			if orig_count > 0 then
				return 0
			else
				return 1
			end
		elseif to_list == "result" then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "crafting" then

	end,
})

