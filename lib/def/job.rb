class Job
	#in order to describe a Job must have 
	#an id , command to run at node, date to start and stop 
	# the number of cpu require for the job and time to 
	# reserve machine a flag comp to define is a job is complete 
	# or no
	attr_accessor :id,:command,:start_d,:stop_d,:h_request,:cpu,:ip_client, :ip_node	
	def initialize(id,command,start_d,stop_d,h_request,cpu,ip_client,ip_node)
		@id = id
		@command = command
		@start_d = start_d
		@stop_d = stop_d 
		@h_request = h_request
		@cpu = cpu
		@ip_client = ip_client
		@ip_node = ip_node 

		
	end
	def persistence(db)
		puts "data base in persistence"
		puts db
		w = Wise.new(db)
		a = w.persistence(self)
		return a
	end
	def persistence_err
		w = Wise.new(db)
                a = persistence_with_error(self)
                return a

	end
end


