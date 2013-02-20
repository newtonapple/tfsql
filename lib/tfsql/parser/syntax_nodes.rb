module Tfsql
  module Parser
    class Node < Treetop::Runtime::SyntaxNode
      def to_code(generator)
        generator.to_code(self)
      end
    end

    # labels: first, rest(element)
    class PrefixListNode < Treetop::Runtime::SyntaxNode
      def all
        @all ||= [first] + tail
      end

      def tail
        rest.elements.map{|e| e.element}
      end

      def text_values
        all.map { |e| e.text_value }
      end

      def size
        all.size
      end
    end

    # labels: first, rest(element), last(element)?
    class ListNode < PrefixListNode
      def tail
        elements = rest.elements.map{|e| e.element}
        elements << last.element unless last.empty?
      end
    end
  end
end