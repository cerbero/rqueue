require 'drb'
require 'sequel'
require 'socket'
require 'yaml'


#require '/home/matteo/sviluppo/rqueue_1.9/lib/setup.rb'
#require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'
#require '/home/matteo/sviluppo/rqueue_1.9/lib/job.rb'

require_relative '../files/setup.rb'
require_relative '../files/wise.rb'
require_relative '../files/job.rb'


class Rqueue

	attr_reader :coda,:db,:url,:sage,:setup,:jobs

	def initialize
		@coda = Queue.new
		@db = Sequel.sqlite("test.db") 
		@setup = Setup.new(@db)
		setup.make_table
		setup.make_parser_machine
		@sage = Wise.new(@db)
		run_queue()
        end
	def getQueue
		@coda
	end

	def enqueue(obj)
                @coda.enq(obj)
        end
	def dequeue
		job = @coda.deq
		puts "in dequeue"
		puts job
	end

	def run_queue 
        	jobs = Array.new
        	jobs = @sage.grab_job_to_exec
        	if jobs != nil
                	jobs.each do |jo|
                        	@coda.enq("request"=>jo)
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
#DRb.start_service 'druby://127.0.0.1:61676',Rqueue.new 
#DRb.start_service 'druby://192.168.13.11:61676',Rqueue.new
puts url 
puts url.class


puts "###########################"
puts "Ok service is on. If you not alredy done  please copy /data/server.yml "
puts "in /data in nodes and clients "
puts "##########################"

hash = Hash.new
hash["url"] = url

File.open('data/server.yml', "w") do |f|
    f.write(YAML::dump hash )
end


DRb.start_service(url,Rqueue.new) 
DRb.thread.join

