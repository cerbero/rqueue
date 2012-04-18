require "rubygems"
require 'ffi'
#require 'ctime'



c = Ctime.getCpuTime # note FFI handles literals just fine



#if ( (errcode = Golden.error_code()) != 0)
#  puts "error calculating something: #{errcode}"
#  exit 1
#end

#objptr = Golden.create_object("my object") # note FFI handles string literals as well
#d = Golden.calculate_something_else(c, objptr)
#Golden.free_object(objptr)


#puts "calculated #{d}"
puts c
