-- lox/AstPrinter.lua
require 'lox/helpers'
require 'token_type'
require 'types/Expr'

-- class AstPrinter

function AstPrinter()
	local t = {
		print = function(expr)
			return expr.accept(self)
		end,
		visitBinaryExpr = function(expr)
			return parenthesize(expr.operator.lexeme, expr.left, expr.right)
		end,
		visitGroupingExpr = function(expr)
			return parenthesize("group", expr.expression)
		end,
		visitLiteralExpr = function(expr)
			if expr.value == null then return "nil" end
			return expr.value.toString()
		end,
		visitUnaryExpr = function(expr)
			return parenthesize(expr.operator.lexeme, expr.right)
		end,

		-- parenthesize, puts strings in parenthesis.
		parenthesize = function (name, ...)
			local builder = StringBuilder()
			builder:append("("):append(name)
			for i, expr in ipairs(arg) do
				builder:append(" ")
				builder:append(expr.accept(self))
			end
			builder:append(")")

			return builder:toString()
		end,

		main = function(...)
			local expression = Expr.Binary(
				Expr.Unary(
					Token(TokenType.MINUS, "-", nil, 1)
					Expr.Literal(123)
				),
				Token(TokenType.STAR, "*", nil, 1),
				Expr.Grouping(
					Expr.literal(45.67)))

			print(AstPrinter():print(expression))
		end,
	}
	return t
end
