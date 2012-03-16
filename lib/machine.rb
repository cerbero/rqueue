require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'

class Machine
	attr_accessor :id,:ip,:name,:cpu,:ssh_user,:ssh_pass,:cpu_load

	def initialize(id,ip,name,cpu,ssh_user,ssh_pass,cpu_load)
		@id = id
		@ip = ip
		@name = name 
		@cpu = cpu
		@ssh_user = ssh_user
		@ssh_pass = ssh_pass
		@cpu_load=0
		DRb.start_service
		queue = DRbObject.new_with_uri('druby://127.0.0.1:61676')
		@db = queue.db
		DRb.stop_service
	end

	def persistence
		w = Wise.new(@db)
		a = w.persistence(self)
		return a
	end
end


