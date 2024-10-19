-- lox/types/Expr.lua

Stmt = {
	["Expression"] = function (expression)
		local t = {}
		t.__typeName = "Expression"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitExpressionStmt(t)
		end
		return t
	end,

	["Print"] = function (expression)
		local t = {}
		t.__typeName = "Print"
		t.expression = expression
		t.accept = function(visitor)
			return visitor.visitPrintStmt(t)
		end
		return t
	end,

	["Var"] = function (name,initializer)
		local t = {}
		t.__typeName = "Var"
		t.name = name
		t.initializer = initializer
		t.accept = function(visitor)
			return visitor.visitVarStmt(t)
		end
		return t
	end,

}
