#! /usr/bin/ruby




class Client
	def initialize
		file_yml = YAML.load_file('../data/config/server.yml')
		@url = file_yml['url']
		puts "here"		
	end

	def start_service 
		DRb.start_service
		queue_class = DRbObject.new_with_uri(@url)

		db = queue_class.getDb
		a  = Setup.new(db)
		a.make_parser_job	

		jobs = Array.new
		jobs =queue_class.sage.grab_job_to_exec
		if jobs != nil
           		jobs.each do |jo|
				queue_class.enqueue("request"=>jo)
             		end
    		end
		DRb.stop_service

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

Client.new.start_service
