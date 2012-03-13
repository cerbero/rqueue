require "rubygems"
require "sequel"
require "parser"

class Setup 

	attr_accessor :db, :file
	
	def initialize
		@db = Sequel.sqlite('../data/test.db')
	end
		
	def make_table	

	@db.create_table? :machine do
	  primary_key :id
	  String :name
	  String :ip
	  Int :cpu
	  String :ssh_user
	  String :ssh_pass
	  String :cpu_load
	end

	@db.create_table? :job_to_exec do
	  primary_key :id
	  String :command
	  String :start_date
	  String :stop_date
	  Int :h_request
	  Int :cpu
	  String :msg1
          String :stderr
	end

	@db.create_table? :job_error do
	  primary_key :id
   	  String :command
  	  String :start_date
 	  String :stop_date
 	  Int :h_request
 	  Int :cpu
  	  String :msg1
	  String :stderr
	end
	end
	
	def make_parser_machine
		@file = "../data/test.yml"
		par = Parser.new(@file)
		par.goParserMachine
	end
	def make_parser_job
                @file = "../data/test_job.yml"
                par = Parser.new(@file)
                par.goParserJob
        end


end

