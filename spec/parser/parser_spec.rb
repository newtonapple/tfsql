require 'debugger'
require 'spec_helper'
Tfsql.load_parser

describe 'TfsqlParser' do
  before do
    @parser = Tfsql::Parser::TFSQLParser.new
  end

  def parse(tfsql)
    @parser.parse(tfsql)
  end


  describe 'Valid Syntax' do
    valid_queries = [
        'select * from "/testfile.txt"',
        "SeleCt *, $0, $1, $2 FROm '/path/to/data'",
        'select *, $1 from "/testfile", \'/path/to/data.txt\'',
        'select a.*, $1, b.*, * from "/path/to/a.db" as a, "/path/to/b.txt" as b',
        'select fromfile.1 firstname, data.2 as lastname, * from "/testfile" as fromfile, \'/path/to/data.txt\' data',
        "SELECT sum ( d.0 ) , aVg(d.1) average, COUNT(d.2) AS count FROM '/path/to/data' GROUP BY d.11 ordeR by d.1, d.2 DESC",
        'select * from "data.txt" where $1 * sin($2) > 5 * $3 and $4 ~ /orbit/',
        'select * from "data.txt" where $1 * sin($2) > 5 * $3 and $4 ~ /ad|bc/ or $4 !~/hello/ group by d6 order by $1, $2 desc limit 5, 500',
        'select * from "data.txt" where !($1 > $2 or $2 > $3) group by d6 order by $1, $2 desc limit 5, 500',
        'select * from "datA.txt" as A JOIN "datB.txt":"\t" as B ON A.1 = B.1 ; ',
        'select * from "datA.txt":" " as A JOIN "datB.txt":"\t" as B WITH (col1, col_2, col__3)  ON A.1 = B.col__3;',
        '   select * from "a.txt" where $1 = "hai";            select * from "b.txt";',
        'select * from "a.txt"; select * from "b.txt" ;;;; select * from "c.txt" '
    ]

    valid_queries.each do |query|
      it("parses #{query}") { parse(query).wont_be_nil }
    end
  end

  describe 'Select Query Syntax Tree' do
    describe "select quantifiers extraction" do
      it 'extracts select quantifiers' do
        select = parse('select * from "textfile.txt"').first.select
        select.quantifiers.text_values.must_equal ['*']

        select = parse('select *, $1, D.1, D.* from "textfile.txt" as D').first.select
        select.quantifiers.text_values.must_equal ['*', '$1', 'D.1', 'D.*']

        select = parse('select $2, C.*, $5, * from "textfile.txt" as C').first.select
        select.quantifiers.text_values.must_equal ['$2', 'C.*', '$5', '*']
      end
    end

    describe 'sources extraction' do
      it 'extracts single source' do
        sources = parse('select * from "textfile.txt":"\n" with (first_name, age:numeric, 3:string)').first.sources
        sources.size.must_equal 1
        source = sources.first
        source.path.must_equal "textfile.txt"
        source.delimiter.must_equal '\n'
        source.schema.size.must_equal 3
        source.schema[0].name.must_equal 'first_name'
        source.schema[0].type.must_equal 'string'
        source.schema[1].name.must_equal 'age'
        source.schema[1].type.must_equal 'numeric'
        source.schema[2].name.must_equal 3
        source.schema[2].type.must_equal 'string'
      end

      it 'extracts multiple sources' do
        sources = parse('select * from "textfile.txt", "/var/log/www/apache.log" as log, \'foo.log\'').first.sources
        sources.size.must_equal 3
        sources.text_values.must_equal ['"textfile.txt"', '"/var/log/www/apache.log" as log', "'foo.log'"]
        sources[1].path.must_equal '/var/log/www/apache.log'
        sources[1].alias.must_equal 'log'
      end
    end

    describe 'joins extraction' do
      it 'extracts no joins' do
        joins = parse('select * from "a.txt"').first.joins
        joins.must_be_empty
      end

      it 'extracts single join without "on" statement (full outer join)' do
        joins = parse('select * from "a.txt" a join "b.txt"').first.joins
        joins.elements.size.must_equal 1
        join = joins.elements[0]
        join.type.must_equal 'join'
        join.source.path.must_equal "b.txt"
        join.source.alias.must_be_nil
        join.on.must_be_nil
      end

      it 'extracts single join with "on" statement' do
        joins = parse('select * from "a.txt" join "b.txt":"\t" b on $2 = b.1').first.joins
        joins.elements.size.must_equal 1
        join = joins.elements[0]
        join.type.must_equal 'join'
        join.source.delimiter.must_equal '\t'
        join.source.path.must_equal "b.txt"
        join.source.alias.must_equal "b"
        join.on[0].table.must_be_nil
        join.on[0].field.must_equal 2
        join.on[1].table.must_equal 'b'
        join.on[1].field.must_equal 1
      end

      it 'extracts multiple joins' do
        joins = parse('select * from "a.txt" a join "b.txt":"\t" b on a.1 = b.1 ljoin "c.txt" on b.1 = c.1').first.joins
        joins.elements.size.must_equal 2
        join = joins.elements[0]
        join.type.must_equal 'join'
        join.source.delimiter.must_equal '\t'
        join.source.path.must_equal "b.txt"
        join.source.alias.must_equal "b"
        join.on[0].text_value.must_equal 'a.1'
        join.on[1].text_value.must_equal 'b.1'
        join = joins.elements[1]
        join.type.must_equal 'ljoin'
        join.source.path.must_equal "c.txt"
        join.source.alias.must_be_nil
        join.source.delimiter.must_equal '\t'
        join.on[0].text_value.must_equal 'b.1'
        join.on[1].text_value.must_equal 'c.1'
      end
    end
  end
end