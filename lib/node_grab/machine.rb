#require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'
require_relative 'wise.rb'

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
	end

	def persistence(db)
		w = Wise.new(db)
		a = w.persistence(self)
		return a
	end
end

