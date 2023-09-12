-- post_fix_function_maker
--
-- A function for building an equaliy assignment in Lua, but one that prevents direct access.


-- ___identifier_postfix_function_ functon is meant to replace an assignment operator
-- for example:
-- ```stim
-- 	name = "Jim"
-- ```
-- In the code above, we replace that whole thing, with this:
-- ```lua
-- Tools["___identifier_postfix_function_="](self, "name", "Jim")
-- ```


Tools = {

	-- redefine the assignment operator.
	["___identifier_postfix_function_="] = function(target, left, right)

		if target.___values == nil then
			target.___values = {}
		end

		-- create the proxy object that holds the data for the thing
		local proxy = {}
		proxy.name = left
		proxy.right = right
		proxy.target = target
		proxy.assignment_function = function(v)
			proxy.target.___values[proxy.name] = v
		end
		proxy.getter_function = function()
			return proxy.target.___values[proxy.name]
		end

		-- set
		target[proxy.name] = proxy.getter_function
		proxy.assignment_function(right)
	end,
}

	-- Usage
	-- When transforming an identifier with a postfix in a block with the assignemnt operator:
	--[[stim
	do
		name = cheese
	end
	--]]
	-- Translates to:
	--[[
		do
			self["___identifier_postfix_function_="]("name", cheese)
		end
	--]]
	-- so it's like a super macro. and it makes code.
