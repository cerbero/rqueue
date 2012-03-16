require 'yaml'
require '/home/matteo/sviluppo/rqueue_1.9/lib/machine.rb'
require 'time'
require 'sequel'

class Parser
	attr_accessor :file
	def initialize(file,db) 
		if File.exist? file  
			@file=file
		else
			raise "File Not Found"
		end
		@db = db
	end
	def goParserMachine
#		db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
		if @db[:machine].empty?		
			begin
				@file_yml = YAML.load_file(@file)
				@file_yml['machine'].each do |mac|
					m = Machine.new mac['id'],mac['ip'],mac['name'],mac['cpu'],mac['ssh_user'],mac['ssh_pass'],0
					m.persistence(@db)
					end
			rescue NoMethodError
				raise "File Not Formatted"
			end
		end
	end
		
	def goParserJob
#		 db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
		 puts @file
                 if @db[:job_to_exec].empty? 
		 	begin
                       		@file_yml = YAML.load_file(@file)
                      		@file_yml['job'].each do |job|
                                	m = Job.new job['id'],job['command'],Time.now.to_s,Time.now.to_s,job['h_request'],job['cpu'],"",""
                               		m.persistence(@db)
                        		end
                	rescue NoMethodError
                        	raise "File Not Formatted"
                	end
		end
end
		
end

