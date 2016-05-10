public class File
{
	private _inputStream: NSInputStream

	init(path: String)
	{
		_inputStream = NSInputStream(filatAtPath: path)
	}

	private func close()
	{
		_inputStream.close()
	}

	public func readOutputData() -> [Float]
	{
		return readFloatData(4)
	}

	public func readSensorData() -> [Float]
	{
		return readFloatData(9)
	}

	public func readRawData() -> [UInt16]
	{
		return readShortData(9)
	}

	public func readFloatData(length: Int) -> [Float]
	{
		var result = [Float]()

		if length > 0 && _inputStream.hasBytesAvailable
		{
			var buffer = [UInt8](count: length * 4, repeatedValue: 0)
			let bytesRead = _inputStream.read(data: &buffer, maxLength: buffer.count) 

			if bytesRead > 0
			{
				result = buffer
			}
		}

		return result
	}

	public func readShortData(length: Int) -> [UInt16]
	{
		var result = [UInt16]()

		if length > 0 && _inputStream.hasBytesAvailable
		{
			var buffer = [UInt16](count: length * 2, repeatedValue: 0)
			let bytesRead = _inputStream.read(data: &buffer, maxLength: buffer.count) 

			if bytesRead > 0
			{
				result = buffer
			}
		}

		return result
	}
}