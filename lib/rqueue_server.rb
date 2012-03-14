require 'rubygems'
require 'drb'

require 'setup'
require 'wise'


setup = Setup.new
setup.make_table
setup.make_parser_machine
@sage = Wise.new


def run_queue(url='druby://127.0.0.1:61676')
	queue = Queue.new
	DRb.start_service(url,queue)
	jobs = Array.new
	jobs = @sage.grab_job_to_exec
	if jobs != nil
		jobs.each do |jo|
			queue.enq("request"=>jo)
		end 
	end
	#to do sostiutirlo con un 
	#demone
	while true 
	end
end

 
	
run_queue()			

