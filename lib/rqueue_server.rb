require 'make_tab'
require 'rake'
require 'drb'
require 'wise'
require 'net/ssh'



def run_queue(url='druby://127.0.0.1:61676')
	Setup.new
	queue = Queue.new
	DRb.start_service(url,queue)
	jobs = Array.new
	jobs = Wise.new.grab_job_to_exec
	if jobs != nil
		jobs.each do |jo|
			queue.enq("request"=>jo,"from"=>NAME)
		end 
	end
	#start code
	while job = queue.deq
                yield job
        end
end

run_queue do |job|
        case job ["request"][0]
		t=Thread.new{mind(job),self}
		t.join
        end
end
 
def mind (job,t)
	
	a = new Wise()
	#sceglie la macchina con il minor spreco di cpu
	b = a.greedy(job.cpu) 
        # chimata ssh del comando con grep dei parametri
	Net::SSH.start(b.ip, b.ssh_user, :password => b.password ) do |ssh|
        ssh.exec b.command do |ch, stream, data|
         if stream == :stderr
                 puts "ERROR: #{data}"
		 # put the job into error table
		 t.kill
        else
                 puts data
		 t.kill
         end
        end
	time_to_kill = b.start_date+(60*60*b.h_request)
	while true do
		 if Time.now == time_to_kill
			t.kill 
			break
	end
	
end

        #controllo se sfora	
			

end
	
	
	


 

 
