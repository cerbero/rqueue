require 'spec_helper'
require 'sequel'

describe Parser do

	describe "#new" do
		it "file yaml dont exist raise error message" do
			 lambda {Parser.new "pippo.yml"}.should raise_exception "File Not Found"			
				 
		end
	end
	describe "#goParse" do
		it "if file not well format raise an error message" do
			p = Parser.new "/home/matteo/sviluppo/rqueue/data/a.out"
			lambda {p.goParserMachine}.should raise_exception "File Not Formatted"
		end
		it "if file is well formatted parser gone with one entry" do
			p = Parser.new '/home/matteo/sviluppo/rqueue/data/test.yml'
			p.goParserMachine
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        db_table = db[:machine]
			db_table.delete
		end
		it "if file is well formatted parser gone with more entry" do 
			p = Parser.new '/home/matteo/sviluppo/rqueue/data/test2.yml'
                        p.goParserMachine
                        db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        db_table = db[:machine]
                        db_table.delete
		end
	end
	
end
