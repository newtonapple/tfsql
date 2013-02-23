require "tfsql/version"
module Tfsql
  module Parser
    KEYWORDS = ['as', 'select', 'from', 'with', 'join', 'ljoin', 'rjoin', 'ojoin', 'on', 'where', 'group', 'having', 'order', 'limit', 'by', 'asc', 'desc']
  end
  def self.load_parser
    require 'treetop'
    require "tfsql/parser/syntax_nodes"
    parser_files_base_path = File.expand_path File.join(File.dirname(__FILE__), 'tfsql', 'parser')
    Treetop.load File.join(parser_files_base_path, 'case_insensitive_alphabet.treetop')
    Treetop.load File.join(parser_files_base_path, 'keywords.treetop')
    Treetop.load File.join(parser_files_base_path, 'symbols.treetop')
    Treetop.load File.join(parser_files_base_path, 'expressions.treetop')
    Treetop.load File.join(parser_files_base_path, 'tfsql.treetop')
  end
end
