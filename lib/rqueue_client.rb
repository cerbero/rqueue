#! /usr/bin/ruby

require 'drb'
require '/home/matteo/sviluppo/rqueue_1.9/lib/wise.rb'
require '/home/matteo/sviluppo/rqueue_1.9/lib/setup.rb'


DRb.start_service
queue = DRbObject.new_with_uri('druby://127.0.0.1:61676')

#puts queue.db

setup = Setup.new(queue.db)
setup.make_parser_job

sage = Wise.new(queue.db)
jobs = Array.new
puts "pre "
jobs = sage.grab_job_to_exec
puts "post"
    if jobs != nil
           jobs.each do |jo|
                queue.coda.enq("request"=>jo)
             end
    end


