require 'rubygems'
require 'drb'
require 'sys/cpu'
require 'open3'
include Sys


#fix a name client for test 

class GrabNode
	def initialize
		@cpu=CPU.processors[0]["cpu_cores"].to_i
	end
	
	def grab_job
		DRb.start_service
		queue = DRbObject.new_with_uri('druby://127.0.0.1:61676')
		puts 'Listening for connection ...'
        	while job = queue.deq
			if job["request"][:cpu].to_i<=@cpu
				exec_job(job)
			end
        	end
	end

	def exec_job(job)
		@stdin, @stdout, @stderr,@wait_thr = Open3.popen3(job["request"][:command])
		puts @wait_thr.value
		write_a_file(job)
		#puts "----------------------------"
		#puts @output.readlines
		#puts "----------------------------"
		#puts @error.readlines
	end

	def write_a_file(job)
		Dir.chdir
		begin
			Dir.mkdir 'rqreport'
		rescue Exception
			
		end
		Dir.chdir 'rqreport'
		File.open(job["request"][:id].to_s+'_'+'out.txt', 'w') do |write|
			write.puts @stdout.readlines
		end
		File.open(job["request"][:id].to_s+'_'+'err.txt', 'w') do |write|
                        write.puts @stderr.readlines
                end

	end

end

GrabNode.new.grab_job

