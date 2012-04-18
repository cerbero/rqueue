require 'ffi'
require_relative 'ctime.rb'


class Sablier

	def CpuTimeStart
		@c1 = Ctime.getCpuTime
	end
	def CpuTimeEnd
		@c2=Ctime.getCpuTime
	end
	def WallTimeStart
		@w1=Ctime.getWallTime
	end
	def WallTimeEnd
                @w2=Ctime.getWallTime
        end
	def CpuTime
		Ctime.calCpuTime(@c1,@c2)
	end
	def WallTime
                Ctime.calcWallTime(@w1,@w2)
        end
	def CpuTimeFree(a,b)
		Ctime.calccalCpuTime(b,a)
	end
	def WallTimeFree(a,b)
                Ctime.calcWallTime(b,a)
        end


end 



