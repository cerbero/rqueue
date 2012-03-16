require "rubygems"
require "sequel"
require "/home/matteo/sviluppo/rqueue_1.9/lib/parser.rb"




class Setup 

	attr_accessor :db, :file
	
	def initialize(db)
		DRb.start_service
#                queue_class = DRbObject.new_with_uri('druby://127.0.0.1:61676')
#		@db = Sequel.sqlite('../data/test.db')
		@db = db
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
		par = Parser.new(@file,@db)
		par.goParserMachine
	end
	def make_parser_job
                @file = "../data/test_job.yml"
                par = Parser.new(@file,@db)
                par.goParserJob
        end


end

