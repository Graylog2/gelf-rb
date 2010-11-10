module GELF
  class Notifier
    @@id = 0

    attr_accessor :host, :port
    attr_reader :max_chunk_size

    # +host+ and +port+ are host/ip and port of graylog2-server.
    def initialize(host = 'localhost', port = 12201, max_size = 'WAN')
      @host, @port, self.max_chunk_size = host, port, max_size
    end

    # +size+ may be a number of bytes, 'WAN' (1420 bytes) or 'LAN' (8154).
    # Default (safe) value is 'WAN'.
    def max_chunk_size=(size)
      s = size.to_s.downcase
      if s == 'wan'
        @max_chunk_size = 1420
      elsif s == 'lan'
        @max_chunk_size = 8154
      else
        @max_chunk_size = size.to_int
      end
    end

    # Same as notify!, but rescues all exceptions (including +ArgumentError+)
    # and sends them instead.
    def notify(*args)
      notify!(*args)
    rescue Exception => e
      notify!(e)
    end

    # Sends message to Graylog2 server.
    # +args+ can be:
    # - hash-like object (any object which responds to +to_hash+, including +Hash+ instance)
    #    notify!(:short_message => 'All your rebase are belong to us', :user => 'AlekSi')
    # - exception with optional hash-like object
    #    notify!(SecurityError.new('ALARM!'), :trespasser => 'AlekSi')
    # - string-like object (anything which responds to +to_s+) with optional hash-like object
    #    notify!('Plain olde text message', :scribe => 'AlekSi')
    # This method will raise +ArgumentError+ if arguments are wrong. Consider using notify instead.
    def notify!(*args)
      do_notify(extract_hash(*args))
    end

  private
    def extract_hash(object_or_exception, args = {})
      primary_data = if object_or_exception.respond_to?(:to_hash)
                       object_or_exception.to_hash
                     elsif object_or_exception.is_a?(Exception)
                       bt = object_or_exception.backtrace || ["Backtrace is not available."]
                       { 'short_message' => "#{object_or_exception.class}: #{object_or_exception.message}",
                         'full_message' => "Backtrace:\n" + bt.join("\n") }
                     else
                       { 'short_message' => object_or_exception.to_s }
                     end

      hash = args.merge(primary_data)

      hash.keys.each do |key|
        value, key_s = hash.delete(key), key.to_s
        raise ArgumentError.new("Both #{key.inspect} and #{key_s} are present.") if hash.has_key?(key_s)
        hash[key_s] = value
      end

      hash['host'] ||= @this_host || detect_this_host

      # for compatibility with HoptoadNotifier
      if hash['short_message'].to_s.empty?
        if hash.has_key?('error_class') && hash.has_key?('error_message')
          hash['short_message'] = "#{hash['error_class']}: #{hash['error_message']}"
          hash.delete('error_class')
          hash.delete('error_message')
        end
      end

      %w(short_message host).each do |a|
        if hash[a].to_s.empty?
          raise ArgumentError.new("Attributes short_message and host must be set.")
        end
      end

      hash
    end

    def do_notify(hash)
      data = Zlib::Deflate.deflate(hash.to_json).bytes
      sock = UDPSocket.open
      datagrams = []

      # Maximum total size is 8192 byte for UDP datagram. Split to chunks if bigger. (GELFv2 supports chunking)
      if data.count > @max_chunk_size
        @@id += 1
        msg_id = Digest::SHA256.digest("#{Time.now.to_f}-#{@@id}")
        i, count = 0, (data.count / 1.0 / @max_chunk_size).ceil
        data.each_slice(@max_chunk_size) do |slice|
          datagrams << chunk_data(slice, msg_id, i, count)
          i += 1
        end
      else
        datagrams = [data.map(&:chr).join]
      end

      datagrams.each { |d| sock.send(d, 0, @host, @port) }
      datagrams
    end

    def chunk_data(data, msg_id, sequence_number, sequence_count)
      # [30, 15].pack('CC') => "\036\017"
      return "\036\017" + msg_id + [sequence_number, sequence_count].pack('nn') + data.map(&:chr).join
    end

    def detect_this_host
      @this_host = Socket.gethostname
    end
  end
end
