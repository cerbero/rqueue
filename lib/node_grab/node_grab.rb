require 'rubygems'
require 'drb'
require 'open3'
require 'facter'
require 'yaml'

#require '/home/matteo/sviluppo/rqueue_1.9/lib/job.rb'
#require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'
require_relative '../files/job.rb'
require_relative '../files/wise.rb' 


#fix a name client for test 

class GrabNode
	def initialize
		Facter.loadfacts
		@cpu = Facter.processorcount.to_i
		file_yml = YAML.load_file('data/server.yml')
      		@url = file_yml['url']
	end
	
	def grab_job
		DRb.start_service
		#@queue_class = DRbObject.new_with_uri('druby://127.0.0.1:61676')
		#@queue_class = DRbObject.new_with_uri('druby://192.168.11.123:61676')
		#@queue_class = DRbObject.new_with_uri('druby://192.168.13.11:61676')
		@queue_class = DRbObject.new_with_uri(@url)
		puts 'Listening for connection ...'

       		while job = @queue_class.coda.deq
			if job["request"].cpu.to_i<=@cpu
				exec_job(job)
			end
        	end
	end

	def exec_job(job)
		@stdin, @stdout, @stderr,@wait_thr = Open3.popen3(job["request"].command)
		puts "here"
		puts @wait_thr.value
		puts @wait_thr.value.class
		puts @wait_thr.value.pid
		puts @wait_thr.value.success?
		write_a_file(job)
			# if job fail put it in the job_error table otherwise
			# puts done and delete from table job_to_exec
			if @wait_thr.value.success? == false
				@wise = Wise.new(@queue_class.db)
				@wise.persistence_with_error(job,"job fail","stderror")
			else
				@wise = Wise.new(@queue_class.db)
				@wise.delete_done_job(job)
			end

		@stdin.close  
		@stdout.close
		@stderr.close
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
		File.open(job["request"].id.to_s+'_'+'out.txt', 'w') do |write|
			write.puts @stdout.readlines
		end
		File.open(job["request"].id.to_s+'_'+'err.txt', 'w') do |write|
                        write.puts @stderr.readlines
                end

	end

end

GrabNode.new.grab_job

