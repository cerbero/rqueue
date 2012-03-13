require 'wise'

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

	def persistence
		w = Wise.new()
		a = w.persistence(self)
		return a
	end
end


