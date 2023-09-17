-- lox/types/Expr.lua

Stmt = {
	["Expression"] = function (expression)
		local t = {}
		t.name = "Expression"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitExpressionStmt(t)
		end
		return t
	end,

	["Print"] = function (expression)
		local t = {}
		t.name = "Print"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitPrintStmt(t)
		end
		return t
	end,

}
