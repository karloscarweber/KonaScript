-- lox/types/Expr.lua

Expr = {
	["Binary"] = function (left,operator,right)
		local t = {}
		t.__typeName = "Binary"
		t.left = left
		t.operator = operator
		t.right = right
		t.accept = function(visitor)
			return visitor.visitBinaryExpr(t)
		end
		return t
	end,

	["Grouping"] = function (expression)
		local t = {}
		t.__typeName = "Grouping"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitGroupingExpr(t)
		end
		return t
	end,

	["Literal"] = function (value)
		local t = {}
		t.__typeName = "Literal"
		t.value = value
		t.accept = function(visitor)
			return visitor.visitLiteralExpr(t)
		end
		return t
	end,

	["Unary"] = function (operator,right)
		local t = {}
		t.__typeName = "Unary"
		t.operator = operator
		t.right = right
		t.accept = function(visitor)
			return visitor.visitUnaryExpr(t)
		end
		return t
	end,

	["Variable"] = function (name)
		local t = {}
		t.__typeName = "Variable"
		t.name = name
		t.accept = function(visitor)
			return visitor.visitVariableExpr(t)
		end
		return t
	end,

}
