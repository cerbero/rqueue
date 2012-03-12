require 'yaml'
require 'machine'

class Parser
	def initialize(file) 
		if File.exist? file  
			@file=file
		else
			raise "File Not Found"
		end
	end
	def goParserMachine
		begin
			@file_yml = YAML.load_file(@file)
			@file_yml['machine'].each do |mac|
				m = Machine.new mac['id'],mac['ip'],mac['name'],mac['cpu']
				m.persistence
			end
		rescue NoMethodError
			raise "File Not Formatted"
		end

	end
	def goParserJob
		 begin
                        @file_yml = YAML.load_file(@file)
                        @file_yml['job'].each do |job|
                                m = Job.new job['id'],job['command'],job['start_d'],'',job['cpu_r'],job['time'],'N'
                                m.persistence
                        end
                rescue NoMethodError
                        raise "File Not Formatted"
                end

	end
		
end

