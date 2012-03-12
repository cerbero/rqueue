require 'wise'

class Machine
	def initialize(id,ip,name,cpu)
		@id = id
		@ip = ip
		@name = name 
		@cpu = cpu
	end
	def getIp
		@ip
	end
	def getId
		@id
	end
	def getName
		@name
	end
	def getCpu
		@cpu
	end
	def persistence
		w = Wise.new()
		a = w.persistence(self)
		return a
	end
end


