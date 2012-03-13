require "rubygems"
require 'drb'
require 'net/ssh'

require 'setup'
require 'wise'


setup = Setup.new
setup.make_table
setup.make_parser_machine
setup.make_parser_job
@sage = Wise.new


def run_queue(url='druby://127.0.0.1:9001')
	queue = Queue.new
	DRb.start_service(url,queue)
	jobs = Array.new
	jobs = @sage.grab_job_to_exec
	if jobs != nil
		jobs.each do |jo|
			queue.enq("request"=>jo)
		end 
	end
	#start code
	while job = queue.deq
                yield job
        end
end

 
def mind (job,job_cpu,t)
	
	#sceglie la macchina con il minor spreco di cpu
	b = @sage.greedy(job_cpu) 
        # chimata ssh del comando con grep dei parametri
	puts "in ssh"
	puts b[:ip]
	puts b[:ssh_user]
	puts b[:ssh_pass]
	puts job[:command]
	Net::SSH.start(b[:ip], b[:ssh_user], :password => b[:ssh_pass] ) do |ssh|
        ssh.exec job[:command] do |ch, stream, data|
         if stream == :stderr
                 puts "ERROR: #{data}"
		 # put the job into error table
		 a.persistence_with_error(job,"Job fail","ERROR: #{data}")
		 t.kill
         else
                 puts data
		 t.kill
         end
        end
	end
	time_to_kill = b.start_date+(60*60*b.h_request)
	while true do
		 if Time.now == time_to_kill
			t.kill 
			break
	end
	
end
			

end

run_queue do |job|
		puts "in block"	
		a_job = job["request"]
		job_cpu = a_job [:cpu]
                
		t=Thread.new{mind(a_job,job_cpu,self)}
                t.join
        end

	
	
	
