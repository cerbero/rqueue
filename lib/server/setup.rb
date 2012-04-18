require "rubygems"
require "sequel"
require_relative 'parser.rb'



class Setup 

	attr_accessor :db, :file
	
	def initialize(db)
		@db = db
	end
		
	def make_table	


	@db.create_table? :job_to_exec do
	  primary_key :id
	  String :command
	  String :start_date
	  String :stop_date
	  Int :h_request
	  Int :cpu
	  String :ip_client
          String :ip_node
	end

	@db.create_table? :job_error do
	  primary_key :id
   	  String :command
  	  String :start_date
 	  String :stop_date
 	  Int :h_request
 	  Int :cpu
	  String :ip_client
          String :ip_node
<<<<<<< HEAD
=======
	end
	
	@db.create_table? :job_done do
          primary_key :id
          String :command
          String :start_date
          String :stop_date
          Int :h_request
          Int :cpu
          String :ip_client
          String :ip_node
        end



>>>>>>> origin/master
	end

	
	
<<<<<<< HEAD
	@db.create_table? :job_done do
          primary_key :id
          String :command
          String :start_date
          String :stop_date
          Int :h_request
          Int :cpu
          String :ip_client
          String :ip_node
=======
	def make_parser_machine
		puts "sono in parser machine"
		@file = "../../data/test.yml"
		par = Parser.new(@file,@db)
		par.goParserMachine
	end
	
	def make_parser_job
		puts "sono in parser"
                @file = "../../data/test_job.yml"
                par = Parser.new(@file,@db)
                par.goParserJob
>>>>>>> origin/master
        end



	end



end

