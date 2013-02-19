module Tfsql::Parser
  class Node < Treetop::Runtime::SyntaxNode
    def to_code(generator)
      generator.to_code(self)
    end
  end

  class ExpressionNode < Node
    def left_expression
    end

    def right_expression
      
    end

    def operator
      
    end

    def to_code(generator)
      
    end
  end
end