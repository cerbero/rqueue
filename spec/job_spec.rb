require 'spec_helper'

describe Job do
	before :each do
		@job=Job.new 1,"ls","18-01-2012:01-01-54" ,"18-01-2012:11-01-54","3","24","N" 
	end
	describe "#new" do
		it "returns a new job object" do
			@job.should be_an_instance_of Job
		end
		it "Argument Error when given fewer arguments" do
			lambda {Job.new "2" "cd"}.should raise_exception ArgumentError
		end
	end
        describe "#save" do
		it "save a job object into database" do
			@job.persistence.should == 1
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			db_table = db[:job] 
			db_table.filter(:id=>1).delete 			 
		end 
	end
	describe "#goParse" do
 		it "if file not well format raise an error message" do
                        p = Parser.new "/home/matteo/sviluppo/rqueue/data/a.out"
                        lambda {p.goParserJob}.should raise_exception "File Not Formatted"
                end
                it "if file is well formatted parser gone with one entry" do
                        p = Parser.new '/home/matteo/sviluppo/rqueue/data/test_job.yml'
                        p.goParserJob
                        db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        db_table = db[:job]
                        db_table.delete
                end
                it "if file is well formatted parser gone with more entry" do 
                        p = Parser.new '/home/matteo/sviluppo/rqueue/data/test2.yml'
                        p.goParserJob
                        db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        db_table = db[:job]
                        db_table.delete
                end
        end
	




end
