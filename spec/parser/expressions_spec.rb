require 'spec_helper'

Tfsql.load_parser

describe Tfsql::Parser::ExpressionsParser do
  before do
    @parser = Tfsql::Parser::ExpressionsParser.new
  end

  def parse(code)
    @parser.parse code
  end
  describe 'valid where expression' do
    VALID_QUERIES = [
      '1 + 2 = 3',
      '(1+2) = 3 * 0 + 3', 
      'd4 * d5 > (d1 * $2) + d3',
      'd.1 > d2 + 2 * d.3',
      '(1 - 2) * 3 / (d.2 % log(3)) > d.5',
      '$1 + $2 > 5 or ($1 + $2) * 7 > $3',
      '($1 + $2) * 2> 5 and ($1 + $2) * 7 > $3',
      '$6 ~ /foo/ and ($1 + $2) * 2> 5 and (($1 + $2) * 7 > $3 or d.name != "stuff" or $3 < $5 + 2 / log($6, 2))'
    ]

    VALID_QUERIES.each do |query|
      it("parses #{query}") { parse(query).wont_be_nil }
    end
  end
end