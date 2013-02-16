# encoding: utf-8
require 'spec_helper'
Tfsql.load_parser

describe 'TfsqlParser' do
  before do
    @parser = Tfsql::Parser::TFSQLParser.new
  end

  describe 'valid syntax' do
    VALID_QUERIES = [
        'select * from "/testfile.txt"',
        "SeleCt *, 0, 1, 2 FROm '/path/to/data'",
        'select *, 1 from "/testfile", \'/path/to/data.txt\''
    ]

    VALID_QUERIES.each do |query|
      it("parses #{query}") { @parser.parse(query).wont_be_nil }
    end
  end
end