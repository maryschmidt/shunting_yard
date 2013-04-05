class RPNCalculator

  OPERATORS = { "+" => 2, "-" => 2, "*" => 4, "/" => 4 }

  def initialize
    @stack = []
  end

  def calculate(postfix_expression)
    input = postfix_expression

    while input.length > 0
      char = input.shift
      if OPERATORS.has_key?(char) && @stack.length >= 2
        operand_two = @stack.pop.to_i
        operand_one = @stack.pop.to_i
        @stack << operand_one.send(char.to_sym, operand_two)
      elsif OPERATORS.has_key?(char) && @stack.length < 2
        input.rotate!
      else
        @stack << char
      end
    end
    @stack
  end
end

class ShuntingYard

  OPERATORS = { "+" => 2, "-" => 2, "*" => 4, "/" => 4 }

  def initialize
    @output_stack = []
    @operator_stack = []
  end

  def shunt(infix)
    infix_chars = infix.split(/\s*/)

    infix_chars.each do |char|
      if OPERATORS.has_key?(char) && @operator_stack.length < 1
        @operator_stack << char
      elsif OPERATORS.has_key?(char) && @operator_stack.length >= 1
        char_ranking = OPERATORS.values_at(char).to_s
        stack_ranking = OPERATORS.values_at(@operator_stack[0]).to_s
        if stack_ranking > char_ranking
          @output_stack << @operator_stack[0]
          @operator_stack << char
        end
      else
        @output_stack << char
      end
    end

    while @operator_stack.length > 0
      @output_stack << @operator_stack.shift
    end

    @output_stack
  end
end

shunting_yard = ShuntingYard.new
postfix = shunting_yard.shunt("5*3-1*2")

calculator = RPNCalculator.new
puts calculator.calculate(postfix)
