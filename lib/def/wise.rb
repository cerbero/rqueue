class Wise
	def initialize(db)
		@db = db
	end
	def persistence(obj)
                @w_type=obj
		puts "in persistence"
		puts @w_type
  		if @w_type.class == Job
			items = @db[:job_to_exec]
			items.insert(:id => @w_type.id,:command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date=>@w_type.stop_d,:h_request=>@w_type.h_request.to_i,:cpu =>@w_type.cpu.to_i, \
				     :ip_client => @w_type.ip_client,:ip_node => @w_type.ip_node)
			puts "end of insertion"
		end

	end

	def persistence_with_error (obj,ip)
			@w_type = obj["request"]
                        items = @db[:job_error]
                        items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date =>"",:h_request=>@w_type.h_request,:cpu =>@w_type.cpu, \
				     :ip_client => @w_type.ip_client,:ip_node =>ip)
	end
	def persistence_done_job(obj,ip)
                        @w_type = obj["request"]
                        items = @db[:job_error]
                        items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
                                     :stop_date =>"",:h_request=>@w_type.h_request,:cpu =>@w_type.cpu, \
                                     :ip_client => @w_type.ip_client,:ip_node => ip )
        end

	def grab_job_to_exec
		jobs = Array.new
        	items = @db[:job_to_exec]
        	if items.count > 0
			items.each{|x| jobs.push Job.new x[:id],x[:command],x[:start_date],x[:stop_date],x[:h_request],x[:cpu],x[:ip_client],x[:ip_node]}
		end
		return jobs
	end

	def delete_done_job(job)
		items = @db[:job_to_exec]
		items.filter(:id => job["request"].id).delete
	end


	def greedy(job_cpu)
		items = @db[:machine]
		machine = items.order(:cpu.asc).filter(:cpu >=job_cpu).first
		
	end

end
