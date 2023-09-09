-- lox/types/Expr.lua

Expr = {
	["Binary"] = function (left,operator,right)
		local t = {}
		t.left = left
		t.operator = operator
		t.right = right
		return t
	end,

	["Grouping"] = function (expression)
		local t = {}
		t.expression = expression
		return t
	end,

	["Literal"] = function (value)
		local t = {}
		t.value = value
		return t
	end,

	["Unary"] = function (operator,right)
		local t = {}
		t.operator = operator
		t.right = right
		return t
	end,

}
