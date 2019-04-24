require 'socket'

namespace :memcached do

  server = '127.0.0.1'
  port = 11211

  desc 'Flushes whole memcached local instance'
  task :flush do
    command = "flush_all\r\n"
    write_to_socket(command, server, port)
  end


  private

  def write_to_socket(command, server, port)
    socket = TCPSocket.new(server, port)
    begin
      STDERR.puts "Executing command: '#{command.inspect}'"
      socket.write(command)
      result = socket.recv(2)
      if result != 'OK'
        STDERR.puts "Error flushing memcached: #{result}"
      end
    rescue Exception => e
      STDERR.puts "An error occurred: #{e.inspect}"
    ensure
      socket.close
      STDERR.puts "Finished."
    end
  end

end