require "rubygems"
require "sequel"

class setup 

	@db = Sequel.sqlite('../data/test.db')

	def initialize()
	
	@db.create_table? :machine do
	  primary_key :id
	  String :name
	  String :ip
	  Int :cpu
	end

	@db.create_table? :job_to_exec do
	  primary_key :id
	  String :command
	  String :start_date
	  Int :h_request
	  Int :cpu
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

end

