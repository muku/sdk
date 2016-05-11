import Foundation

public class File
{
	private let _inputStream: NSInputStream

	init(path: String)
	{
		_inputStream = NSInputStream(fileAtPath: path)
	}

	private func close()
	{
		_inputStream.close()
	}

	public func readOutputData() -> [Float]
	{
		return readFloatData(length: 4)
	}

	public func readSensorData() -> [Float]
	{
		return readFloatData(length: 9)
	}

	public func readRawData() -> [UInt16]
	{
		return readShortData(length: 9)
	}

	public func readFloatData(length: Int) -> [Float]
	{
		var result = [Float]()

		if length > 0 && _inputStream.hasBytesAvailable
		{
			var buffer = [UInt8](repeating: 0, count: length * 4)
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
			var buffer = [UInt16](repeating: 0, count: length * 2)
			let bytesRead = _inputStream.read(data: &buffer, maxLength: buffer.count) 

			if bytesRead > 0
			{
				result = buffer
			}
		}

		return result
	}
}
