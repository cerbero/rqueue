require 'drb'
require 'sequel'

#require '/home/matteo/sviluppo/rqueue_1.9/lib/setup.rb'
#require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'
#require '/home/matteo/sviluppo/rqueue_1.9/lib/job.rb'

require_relative 'setup.rb'
require_relative 'wise.rb'
require_relative 'job.rb'


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


#DRb.start_service 'druby://127.0.0.1:61676',Rqueue.new 
#DRb.start_service 'druby://192.168.11.123:61676',Rqueue.new
DRb.start_service 'druby://192.168.13.11:61676',Rqueue.new
DRb.thread.join

