-- lox/types/Expr.lua

Expr = {
	["Binary"] = function (left,operator,right)
		local t = {}
		t.name = "Binary"
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
		t.name = "Grouping"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitGroupingExpr(t)
		end
		return t
	end,

	["Literal"] = function (value)
		local t = {}
		t.name = "Literal"
		t.value = value
		t.accept = function(visitor)
			return visitor.visitLiteralExpr(t)
		end
		return t
	end,

	["Unary"] = function (operator,right)
		local t = {}
		t.name = "Unary"
		t.operator = operator
		t.right = right
		t.accept = function(visitor)
			return visitor.visitUnaryExpr(t)
		end
		return t
	end,

}
