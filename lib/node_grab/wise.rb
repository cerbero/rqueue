require "rubygems"
require "sequel"
#require '/home/matteo/sviluppo/rqueue_1.9/lib/job.rb'
require_relative 'job.rb'
require 'date'
require 'time'


class Wise
	def initialize(db)
		@db = db
	end
	def persistence(obj)
                @w_type=obj
		puts "in persistence"
		puts @w_type
		if @w_type.class == Machine
			items = @db[:machine]
			items.insert(:id => @w_type.id, :name => @w_type.name, :ip=>@w_type.ip, :cpu=>@w_type.cpu, \
                                     :ssh_user=> @w_type.ssh_user, :ssh_pass=>@w_type.ssh_pass,:cpu_load=>@w_type.cpu_load)
  		elsif @w_type.class == Job
			items = @db[:job_to_exec]
			puts "all'interno di query"
			puts @db
			puts @w_type.id.class
			puts @w_type.command.class
			puts @w_type.start_d.class
			puts @w_type.stop_d.class
			puts @w_type.h_request.class
			puts @w_type.cpu.class
			#puts @w_type.msg.class
			puts @w_type.stderr.class
			items.insert(:id => @w_type.id,:command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date=>@w_type.stop_d,:h_request=>@w_type.h_request.to_i,:cpu =>@w_type.cpu.to_i, \
                                     #:msg=>@w_type.msg,:stderr=> @w_type.stderr
                                     )
			puts "end of insertion"
		end

	end

	def persistence_with_error (obj,msg1,stderr)
			@w_type = obj["request"]
                        items = @db[:job_error]
                        items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date =>"",:h_request=>@w_type.h_request,:cpu =>@w_type.cpu, \
				     :msg=>@w_type.msg,:stderr=>@w_type.stderr)
	end

	def grab_job_to_exec
		jobs = Array.new
        	items = @db[:job_to_exec]
        	if items.count > 0
			items.each{|x| jobs.push Job.new x[:id],x[:command],x[:start_date],x[:stop_date],x[:h_request],x[:cpu],x[:msg],x[:stderr]}
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
