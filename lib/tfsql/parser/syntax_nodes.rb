module Tfsql
  module Parser
    # labels: first, rest(element)
    class PrefixListNode < Treetop::Runtime::SyntaxNode
      include Enumerable

      def each
        all.each {|e| yield e}
      end

      def all
        @all ||= [first] + tail
      end

      def [](position)
        all[position]
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


    class SourceNode < Treetop::Runtime::SyntaxNode
      def path
        source_path.string.text_value
      end

      def delimiter
        source_delimiter.empty? ? '\t' : source_delimiter.nonempty_string.string.text_value
      end

      def alias
        source_alias.empty? ? nil : source_alias.name.text_value
      end

      def schema
        source_schema.empty? ? nil : source_schema
      end
    end


    class SchemaColumnNode < Treetop::Runtime::SyntaxNode
      def name
        Integer column_name.text_value
      rescue ArgumentError
        column_name.text_value
      end

      def type
        column_type.empty? ? 'string' : column_type.type.text_value
      end
    end
  end
end