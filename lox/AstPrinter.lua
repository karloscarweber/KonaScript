-- lox/AstPrinter.lua
require 'lox/helpers'
require 'token_type'
require 'lox/types/Expr'
require 'token'

-- class AstPrinter

function AstPrinter()
	local t = {}
	t = {
		print = function(expr)
			return expr.accept(t)
		end,
		visitBinaryExpr = function(expr)
			return t.parenthesize(expr.operator.lexeme, expr.left, expr.right)
		end,
		visitGroupingExpr = function(expr)
			return t.parenthesize("group", expr.expression)
		end,
		visitLiteralExpr = function(expr)
			if expr.value == null then return "nil" end
			return expr.value
		end,
		visitUnaryExpr = function(expr)
			return t.parenthesize(expr.operator.lexeme, expr.right)
		end,

		-- parenthesize, puts strings in parenthesis.
		parenthesize = function (name, ...)
			local arg = {...}
			local bf = ""
			bf = bf .. "(".. name
			for _,v in ipairs(arg) do
				bf = bf .. " "
				bf = bf .. v.accept(t)
			end
			bf = bf .. ")"
			return bf
		end,
	}
	return t
end

-- Test output
-- local printer = AstPrinter()
-- local expression = Expr.Binary(
-- 	Expr.Unary(
-- 		Token(TokenType.MINUS, "-", nil, 1),
-- 		Expr.Literal(123)
-- 	),
-- 	Token(TokenType.STAR, "*", nil, 1),
-- 	Expr.Grouping(
-- 		Expr.Literal(45.67)))

-- print(printer.print(expression))
-- Expected output: (* (- 123) (group 45.67))
