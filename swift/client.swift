public class Client
{

  	private var _inputStream: NSInputStream = nil

  	private var _outputStream: NSOutputStream = nil

	  /** Keep track of our own connection state that does supports timeouts. */
  	private var _connected: Bool = false

	  /** String description of the remote service. */
  	private var _description: String = ""

	  /** Last XML message received. */
  	private var _xmlString: String = ""

	  /**
	    Default value, in seconds, for the socket receive time out
	    in the Client#readData method.
	  */
  	private let _timeOutReadData: Int = 1

	  /**
	    Default value, in seconds, for the socket send time out
	    in the Client#writeData method.
	  */
  	private let _timeOutWriteData: Int = 1

	  /**
	    Default value, in seconds, for the socket receive time out
	    in the Client#waitForData method. Zero denotes blocking receive.
	  */
  	private let _timeOutWaitForData: int = 5

	  /**
	    Set the address to this value if we get an empty string.
	  */
  	private let _defaultAddress: String = "127.0.0.1"

	  /**
	    Detect XML message with the following header bytes.
	  */
  	private let _xmlMagic: String = "<?xml"

	  /**
	    Set a limit on the incoming message size. Assume that there is
	    something wrong if a message is "too long".
	  */
	private let _maxMessageLength: Int = 65535

	//Constructor
	init(host: String, port: Int)
	{
		if host.isEmpty
		{
			host = _defaultAddress
		}

		if port < 0
		{
			port = 0
		}

		var nsHost: NSHost = NSHost(address: host)

		NSStream.getStreamsToHost(host, port: port, inputStream: &_inputStream, outputStream: &_outputStream)

		_inputStream.open()
		_outputStream.open()
		_connected = true

		var message = receive()

		if message.count > 0
		{
			if !_description = String(data: data, encoding: NSUTF8StringEncoding) 
			{
			    print("not a valid UTF-8 sequence")
			} 
		}
	}

	public func close()
	{
		_inputStream.close()
		_outputStream.close()
		_connected = false
		_description = ""
		_xmlString = ""
	}

	public func isConnected() -> Bool 
	{
		return _connected
	}

	public func readData(timeOutSecond: Int) -> [UInt8]
	{
		var data = [UInt8]()

		if isConnected()
		{
			if timeOutSecond < 0
			{
				//_timeOutReadData
			}
			else
			{
				//timeOutSecond
			}

			var message = receive()

			if message.count >= _xmlMagic.count
			{
				//Convert to string
				let str = String(data: message, encoding: NSUTF8StringEncoding) 

				//if it is an xml string starting with the magic value
				if str.hasPrefix(_xmlMagic)
				{
					_xmlString = str
					message = receive()
				}
			}

			if message.count > 0
			{
				data = message
			}
		}

		return data
	}

	public func readData() -> [UInt8]{
		return readData(-1)
	}

	public func waitForData(timeOutSecond: Int) -> Bool
	{
		var result: Bool = false

		if isConnected()
		{
			if timeOutSecond < 0
			{
				//_timeOutReadData
			}
			else
			{
				//timeOutSecond
			}

			var message = receive()

			if message.count >= _xmlMagic.count
			{
				//Convert to string
				let str = String(data: message, encoding: NSUTF8StringEncoding) 

				//if it is an xml string starting with the magic value
				if str.hasPrefix(_xmlMagic)
				{
					result = true
				}
			}
		}

		return result
	}

	public func waitForData() -> Bool{
		return waitForData(-1)
	}

	public func writeData(data: [UInt8], timeOutSecond: Int) -> Bool
	{
		var result: Bool = false

		if isConnected()
		{
			if timeOutSecond < 0
			{
				//_timeOutReadData
			}
			else
			{
				//timeOutSecond
			}

			if(data.count > 0 data.count < _maxMessageLength)
			{
				//length in network byte order
				let length: UInt32 = CFSwapInt32HostToBig((UInt32)data.count)

				let header: [UInt8] = Converter.AnyToByteArray(length)
				let writeData: [UInt8] = header + data

				let bytesWritten = _outputStream.write(UnsafePointer<UInt8>(writeData), maxLength: writeData.count)

				if bytesWritten > 0
				{
					result = true
				}
			}
		}

		return result
	}

	public func writeData(data: [UInt8]) -> Bool
	{
		return writeData(data, -1)
	}

	public func writeData(message: String, time_out_second: Int) -> Bool
	{
		let data: [UInt8] = [UInt8](message.utf8)
		writeData(data, time_out_second)
	}

	public func writeData(message: String) -> Bool
	{
		return writeData(message, -1)
	}

	public func getXMLString() -> String
	{
		return _xmlString
	}

	public func getSocket() -> Stream
	{
		return _socket
	}

	private func receive() -> [UInt8]
	{
		var data = [UInt8]()

		if isConnected()
		{
			//first read the length of the data
			var lengthBuffer: [UInt8](count: 4)
			if _inputStream.hasBytesAvailable 
			{
    			let bytesRead :Int = _inputStream.read(&lengthBuffer, maxLength: 4)

    			//Convert to int and read the actual data
    			if bytesRead > 0
    			{
    				//length will be big endian
    				let messageLength = Converter.ConvertToInt32(lengthBuffer)

    				if _inputStream.hasBytesAvailable && messageLength > 0 && messageLength <= _maxMessageLength
					{
				    	_inputStream.read(&data, maxLength: messageLength)
				    }
    			}

			}
			
		}
		
		return data
	}
}