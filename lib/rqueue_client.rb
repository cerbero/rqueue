#! /usr/bin/ruby

require 'drb'
require 'wise'
require 'setup'


DRb.start_service
queue = DRbObject.new_with_uri('druby://127.0.0.1:61676')

setup = Setup.new
setup.make_parser_job
@sage = Wise.new
jobs = Array.new
jobs = @sage.grab_job_to_exec
    if jobs != nil
           jobs.each do |jo|
                queue.enq("request"=>jo)
             end
    end
DRb.stop_service


