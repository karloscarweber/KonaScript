-- lox/Parser.lua
--
-- The parser for our Lua based Programming language

require 'lox/token_type'
require 'lox/Lox'

-- Parser
-- Generates a new parser object
--
-- 	@tokens - An array of tokens
--  @current - an int representing the current token, starts at 1.
--
-- 	init(@tokens) - implicit contstructor, accepts a tokens parameter.
Parser = function(tokens)
	t = {}
	t.tokens = {}
	t.current = 1 -- 1 terminated because this is Lua.
	t.tokens = tokens
	return t
end

-- functions that parse the syntax tree and return Raw Lua code

PS_expression = function()
	return PS_equality()
end

PS_equality = function()
	local expr = PS_comparison()

	while (PS_match(BANG_EQUAL, EQUAL_EQUAL)) do
		local operator = PS_previous()
		local right =  PS_comparison()
		expr = Expr.Binary(expr, operator, right)
	end

	return expr
end

PS_comparison = function()
	local expr = PS_term()

	while(PS_match(GREATER, GREATER_EQUAL, LESS, LESS_EQUAL)) do
		local operator = PS_previous()
		local right = PS_term()
		expr = Expr.Binary(expr, operator, right)
	end

	return expr
end

PS_term = function()
	local expr = PS_factor()

	while(PS_match(MINUS, PLUS)) do
		local operator = PS_previous()
		local right = PS_factor()
		expr = Expr.Binary(expr, operator, right)
	end

	return expr
end

PS_factor = function()
	local expr = unary()

	while(PS_match(SLASH, STAR)) do
		local operator = PS_previous()
		local right = unary()
		expr = Expr.Binary(expr, operator, right)
	end

	return expr
end

PS_unary = function()
	if(PS_match(BANG, MINUS)) then
		local operator = PS_previous()
		local right = PS_unary()
		return Expr.Unary(operator, right)
	end
	return primary()
end

PS_primary = function()
	if (PS_match(FALSE)) then return Expr.Literal(false) end
	if (PS_match(TRUE)) then return Expr.Literal(true) end
	if (PS_match(NIL)) then return Expr.Literal(nil) end

	if(PS_match(NUMBER, STRING)) then
		return Expr.Literal(PS_previous().literal)
	end

	if(PS_match(LEFT_PAREN)) then
		local expr = PS_expression()
		PS_consume(RIGHT_PAREN, "Expect ')' after expression.")
		return Expr.Grouping(expr)
	end
end

PS_match = function(...)
	local types = {...}
	for _,type in ipairs(types) do
		if PS_check(type) then
			PS_advance()
			return true
		end
	end

	return false
end

PS_consume = function(type, message)
	if check(type) then return advance() end

	throw error(peek(), message)
end

PS_check = function(type)
	if PS_isAtEnd() then return false end
	return (PS_peek().type == type)
end

PS_advance = function()
	if (!PS_isAtEnd()) then current++ end
	return PS_previous();
end

PS_isAtEnd = function()
	return PS_peek().type == EOF
end

PS_peek = function()
	return tokens.get(current)
end

PS_previous = function()
	return tokens.get(current-1))
end

PS_error = function(token, message)
	Lox.error(token, message)
	return ParseError()
end
