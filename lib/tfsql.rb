require "tfsql/version"

module Tfsql
  def self.load_parser
    require 'treetop'
    parser_files_base_path = File.expand_path File.join(File.dirname(__FILE__), 'tfsql', 'parser')
    Treetop.load File.join(parser_files_base_path, 'case_insensitive_alphabet.treetop')
    Treetop.load File.join(parser_files_base_path, 'tfsql.treetop')
  end
  # Your code goes here...
end
