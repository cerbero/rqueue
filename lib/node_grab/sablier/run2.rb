require "rubygems"
require 'ffi'
require 'sablier'

a = Sablier.new
puts a.CpuTimeStart
puts a.WallTimeStart

sleep(60)

puts a.CpuTimeEnd
puts a.WallTimeEnd 

puts "Wall Time is "
puts a.WallTime
puts "Cpu time is"
puts a.CpuTime


