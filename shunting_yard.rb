class RPNCalculator

  OPERATORS = { "+" => 2, "-" => 2, "*" => 4, "/" => 4 }

  def initialize
    @stack = []
  end

  def calculate(postfix_expression)
    input = postfix_expression

    while input.length > 0
      char = input.shift
      if operator_and_sufficient_operands?(char)
        perform_calculation_and_push char
      elsif need_more_operands?(char)
        input.rotate!
      else
        push_char_to_stack char
      end
    end
    @stack
  end

  private

  def operator_and_sufficient_operands?(char)
    operator?(char) && @stack.length >= 2
  end

  def operator? char
    OPERATORS.has_key?(char)
  end

  def perform_calculation_and_push char
    operand_two = @stack.pop.to_i
    operand_one = @stack.pop.to_i
    @stack << operand_one.send(char.to_sym, operand_two)
  end

  def need_more_operands?(char)
    OPERATORS.has_key?(char) && @stack.length < 2
  end

  def push_char_to_stack char
    @stack << char
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
      if digit?(char)
        move_char_to_output(char)
      elsif operator?(char)
        operator_strategy char
      else
      end
    end

    while @operator_stack.length > 0
      @output_stack << @operator_stack.shift
    end

    @output_stack
  end

    private

    def digit? char
      char =~ /^[-+]?[0-9]*\.?[0-9]+$/
    end

    def operator? char
      OPERATORS.has_key?(char)
    end

    def operator_strategy char
      if @operator_stack.empty?
        @operator_stack << char
      else pop_operator_to_output char
      end
    end

    def pop_operator_to_output char
      char_ranking = OPERATORS[char]
      stack_ranking = OPERATORS[@operator_stack.last]
      while stack_ranking && stack_ranking >= char_ranking
        @output_stack << @operator_stack.pop
        stack_ranking = OPERATORS[@operator_stack.last]
      end
      @operator_stack << char
    end

    def move_char_to_output char
      @output_stack << char
    end
end

shunting_yard = ShuntingYard.new
postfix = shunting_yard.shunt("6*3*3-8/4+4")

calculator = RPNCalculator.new
puts calculator.calculate(postfix)
