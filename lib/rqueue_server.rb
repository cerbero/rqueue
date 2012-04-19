require '../lib/rqueue.rb'

class Rqueue

	attr_reader :coda,:db,:url,:sage,:setup,:jobs

	def initialize
		@coda = Queue.new
		@db = Sequel.connect('jdbc:sqlite:../data/rqueue.db',:servers=>{})
		@setup = Setup.new(@db)
		setup.make_table
		@sage = Wise.new(@db)
		run_queue()
        end

	def enqueue(obj)
                @coda.push(obj)
        end
	def dequeue
		@coda.deq
	end
	def print 
		@coda.size 
	end
	def getDb
		@db
	end
	def run_queue 
        	jobs = Array.new
        	jobs = @sage.grab_job_to_exec
        	if jobs != nil
                	jobs.each do |jo|
				self.enqueue("request"=>jo)
                	end
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

url = 'druby://'+local_ip+':61676'
#puts url 
#puts url.class


puts "###########################"
puts "Ok service is on. If you not alredy done  please copy /data/server.yml "
puts "in /data in nodes and clients "
puts "##########################"

hash = Hash.new
hash["url"] = url

File.open('../data/config/server.yml', "w") do |f|
    f.write(YAML::dump hash )
end

 a = Rqueue.new
 DRb.start_service(url,a)
 #DRb.start_service 'druby://192.168.11.123:61676', Rqueue.new
 DRb.thread.join

