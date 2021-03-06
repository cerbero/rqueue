module JavaLang                    # create a namespace for java.lang
  include_package "java.lang"      # use java native thread instead of ruby thread
end

class ThreadImpl
  include JavaLang::Runnable       # include interface as a 'module'

  attr_reader :runner,:cpu_r,:url,:job,:obj,:stdin,:stdout,:stderr,:wait_thr,:wise,:queue_class   # instance variables

	def initialize(job,cpu_r,queue_class)
		@runner = JavaLang::Thread.current_thread # get access to main thread
		@job=job
		@cpu_r=cpu_r
		@queue_class = queue_class

	end

	def run
		begin
			#take time
			#a = Sablier.new
			#a.CpuTimeStart
                        #a.WallTimeStart 
			#for time

			status = Timeout::timeout(@job["request"].h_request.to_i*60*60){
			@stdin, @stdout, @stderr = Open3.popen3(@job["request"].command)
			write_a_file(@job)
			@stdin.close
                	@stdout.close
                	@stderr.close
			
			@wise = Wise.new(@queue_class.getDb)
			@wise.persistence_done_job(@job,local_ip)
                	@wise.delete_done_job(@job)
			$cpu = $cpu + @cpu_r
		
			#for time
			#a.CpuTimeEnd
            #a.WallTimeEnd
            #puts "Wall Time is "
            #puts a.WallTime
            #puts "Cpu time is"
            #puts a.CpuTime
			
		}

		rescue Exception => e
			@wise = Wise.new(@queue_class.getDb)
			@wise.delete_done_job(@job)
                        @wise.persistence_with_error(@job,local_ip)
		end

	end

     def write_a_file(job)
		Dir.chdir
                begin 
                        Dir.mkdir 'rqreport'
                rescue Exception
                end
                Dir.chdir 'rqreport'

		
		begin
                File.open(job["request"].id.to_s+'_'+'out.txt', 'w') do |write|
                        write.puts @stdout.readlines
                end
                File.open(job["request"].id.to_s+'_'+'err.txt', 'w') do |write|
                        write.puts @stderr.readlines
                end
		rescue Exception => e 
			puts "Error in write : "
			puts e.message

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

	

end

class Grab
	def initialize()
		file_yml = YAML.load_file('../data/config/server.yml')
		@url = file_yml['url']
		Facter.loadfacts
		$cpu = Facter.processorcount.to_i

	end
	def start_service
		DRb.start_service
		@queue_class = DRbObject.new_with_uri(@url)
		puts 'Listening for connection ...'
		puts "--------------------------------"
		
		
		while job = @queue_class.dequeue
			if job["request"].cpu.to_i<=$cpu			
				t = JavaLang::Thread.new(ThreadImpl.new(job,job["request"].cpu.to_i,@queue_class)).start	
				$cpu = $cpu-job["request"].cpu.to_i
			else	
				@queue_class.enqueue(job)
				
			end
		end
	end 
end

Grab.new.start_service
