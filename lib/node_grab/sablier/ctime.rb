require "rubygems"
require "ffi"

module Ctime
  extend FFI::Library
  ffi_lib "/home/matteo/sviluppo/rqueue_jruby/lib/node_grab/sablier/libc/libctime.so"
  attach_function :getWallTime, [], :long
  attach_function :getCpuTime, [], :double
  attach_function :calcWallTime, [:long,:long], :long
  attach_function :calCpuTime, [:int,:int], :double
#  attach_function :error_code, [], :int # note empty array for functions taking zero arguments
#  attach_function :create_object, [:string], :pointer
#  attach_function :calculate_something_else, [:double, :pointer], :double
#  attach_function :free_object, [:pointer], :void
end
