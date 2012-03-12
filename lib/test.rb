begin
stdin, stdout, stderr = Open3.popen3('abc')
rescue Exception
puts "error"
end

