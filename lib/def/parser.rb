
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
	
	def goParserJob
                 if @db[:job_to_exec].empty? 
		 	begin
				puts "inizio caricare"
                       		@file_yml = YAML.load_file(@file)
                      		@file_yml['job'].each do |job|
                                	m = Job.new job['id'],job['command'],Time.now.to_s,Time.now.to_s,job['h_request'],job['cpu'],local_ip,""
                               		m.persistence(@db)
                        		end
                	rescue NoMethodError
                        	raise "File Not Formatted"
                	end
		end
	end

	def local_ip
  		orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS
		UDPSocket.open do |s|
    			s.connect '64.233.187.99', 1
    			s.addr.last
  			end
		ensure
  		Socket.do_not_reverse_lookup = orig #reverse dns on
	end

		
end

