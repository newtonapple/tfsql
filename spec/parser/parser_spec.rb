require 'spec_helper'
Tfsql.load_parser

describe 'TfsqlParser' do
  before do
    @parser = Tfsql::Parser::TFSQLParser.new
  end

  describe 'valid syntax' do
    VALID_QUERIES = [
        'select * from "/testfile.txt"',
        "SeleCt *, $0, $1, $2 FROm '/path/to/data'",
        'select *, $1 from "/testfile", \'/path/to/data.txt\'',
        'select a.*, $1, b.*, * from "/path/to/a.db" as a, "/path/to/b.txt" as b',
        'select fromfile.1 firstname, data.2 as lastname, * from "/testfile" as fromfile, \'/path/to/data.txt\' data',
        "SELECT sum ( d.0 ) , aVg(d.1) average, COUNT(d.2) AS count FROM '/path/to/data' GROUP BY d.11 ordeR by d.1, d.2 DESC",
        'select * from "data.txt" where $1 * sin($2) > 5 * $3 and $4 ~ /orbit/',
        'select * from "data.txt" where $1 * sin($2) > 5 * $3 and $4 ~ /ad|bc/ or $4 !~/hello/ group by d6 order by $1, $2 desc limit 5, 500',
        'select * from "data.txt" where !($1 > $2 or $2 > $3) group by d6 order by $1, $2 desc limit 5, 500',
        'select * from "datA.txt" as A JOIN("\n") "datB.txt" as B ON A.1 = B.1'
    ]

    VALID_QUERIES.each do |query|
      it("parses #{query}") { @parser.parse(query).wont_be_nil }
    end
  end
end