require "rubygems"
require "sequel"
require 'job'
require 'date'
require 'time'


class Wise
	def initialize
	#per il calcolo del tempo preferisco metterlo nel costrutture visto che 
	#viene richiamato ogni volta che faccio la persistenza 
	end
	def persistence(obj)
                @w_type=obj
		if @w_type.class == Machine
#			db = SQLite3::Database.open("/home/matteo/sviluppo/rqueue/data/test.db")
#			db.prepare("INSERT INTO machine(id,name,ip,cpu) VALUES( ?,?,?,? )") do |stmt|
#    				stmt.execute(@w_type.getId,@w_type.getName,@w_type.getIp,@w_type.getCpu)
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			items = db[:machine]
			items.insert(:id => @w_type.id, :name => @w_type.name, :ip=>@w_type.ip, :cpu=>@w_type.cpu, \
                                     :ssh_user=> @w_type.ssh_user, :ssh_pass=>@w_type.ssh_pass,:cpu_load=>@w_type.cpu_load)
  		elsif @w_type.class == Job
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			items = db[:job_to_exec]
			items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date=>@w_type.stop_d,:h_request=>@w_type.h_request,:cpu =>@w_type.cpu, \
                                     :msg=>@w_type.msg,:stderr=> @w_type.stderr)
		end

	end

	def persistence_with_error (obj,msg1,stderr)
			@w_type = obj
		        db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        items = db[:job_error]
                        items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date =>"",:h_request=>@w_type.time,:cpu =>@w_type.cpu_r, \
				     :msg1=>@w_type.msg1,:stderr=>@w_type.stderr)
	end

	def grab_job_to_exec
		jobs = Array.new	
		db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
        	items = db[:job_to_exec]
        	if items.count > 0
			items.each{|x| jobs.push Job.new x[:id],x[:command],x[:start_date],x[:stop_date],x[:h_request],x[:cpu],x[:msg],x[:stderr]}
		end
	end
	def greedy(job_cpu)
		db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
		items = db[:machine]
		machine = items.order(:cpu.asc).filter(:cpu >=job_cpu).first
		
	end

end
