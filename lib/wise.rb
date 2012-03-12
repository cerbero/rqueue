require "rubygems"
require "sequel"
require 'job'
require 'date'
require 'time'


class Wise
	def initialize
	#per il calcolo del tempo preferisco metterlo nel costrutture visto che 
	#viene richiamato ogni volta che faccio la persistenza 
	@time = Time.now
	end
	def persistence(obj)
                @w_type=obj
		if @w_type.class == Machine
#			db = SQLite3::Database.open("/home/matteo/sviluppo/rqueue/data/test.db")
#			db.prepare("INSERT INTO machine(id,name,ip,cpu) VALUES( ?,?,?,? )") do |stmt|
#    				stmt.execute(@w_type.getId,@w_type.getName,@w_type.getIp,@w_type.getCpu)
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			items = db[:machine]
			items.insert(:id => @w_type.getId, :name => @w_type.getName, :ip=>@w_type.getIp, :cpu=>@w_type.getCpu)
  		elsif @w_type.class == Job
			db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
			items = db[:job_to_exec]
			items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@time.to_s, \
				     :h_request=>@w_type.time,:cpu =>@w_type.cpu_r)
		end

	end

	def persistence_with_error (obj,msg1,stderr)
		        db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
                        items = db[:job_error]
                        items.insert(:id => @w_type.id, :command => @w_type.command, :start_date=>@w_type.start_d, \
				     :stop_date =>"",:h_request=>@w_type.time,:cpu =>@w_type.cpu_r, \
				     :msg1:=>msg1,:stderr:=>stderr)
	end

	def grab_job_to_exec
		jobs = Array.new	
		db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
        	items = db[:job_to_exec]
        	if items.count > 0
			Artist.each{|x| jobs.push Job x.id x.command x.start_date x.h_request x.cpu}
		end
	end
	def greedy(job)
		db = Sequel.sqlite "/home/matteo/sviluppo/rqueue/data/test.db"
		items = db[:machine]
		machine = items.order(:cpu).filter(:cpu=>'>=job.cpu').first
		

	end

end
