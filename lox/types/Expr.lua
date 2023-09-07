-- lox

--import nothing

Expr = {
		function Binary ()
			function Expr left, Token operator, Expr right ()
				this.Expr = Expr
				this.left = left
				this.Token = Token
				this.operator = operator
				this.Expr = Expr
				this.right = right
			end

		final Expr;
		final left;
		final Token;
		final operator;
		final Expr;
		final right;
	end
		function Grouping ()
			function Expr expression ()
				this.Expr = Expr
				this.expression = expression
			end

		final Expr;
		final expression;
	end
		function Literal ()
			function Object value ()
				this.Object = Object
				this.value = value
			end

		final Object;
		final value;
	end
		function Unary ()
			function Token operator, Expr right ()
				this.Token = Token
				this.operator = operator
				this.Expr = Expr
				this.right = right
			end

		final Token;
		final operator;
		final Expr;
		final right;
	end
end

