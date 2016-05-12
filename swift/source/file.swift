import Foundation

public class File
{
	private let _inputStream: NSInputStream?

	init(path: String)
	{
		_inputStream = NSInputStream(fileAtPath: path)

		if _inputStream == nil
		{
			//throw
		}
	}

	private func Close()
	{
		_inputStream!.close()
	}

	public func ReadOutputData() -> [Float]
	{
		return ReadFloatData(length: 4)
	}

	public func ReadSensorData() -> [Float]
	{
		return ReadFloatData(length: 9)
	}

	public func ReadRawData() -> [Int16]
	{
		return ReadShortData(length: 9)
	}

	public func ReadFloatData(length: Int) -> [Float]
	{
		var result = [Float](repeating: 0.0, count: length)

		if length > 0 && _inputStream!.hasBytesAvailable
		{
			var buffer = [UInt8](repeating: 0, count: length * 4)
			let bytesRead = _inputStream!.read(&buffer, maxLength: buffer.count) 

			if bytesRead > 0
			{
				for i in 0 ..< length
				{
					let floatBytes = buffer[i*4..<i*4+4]
					result[i] = Converter.ConvertToSingle(buffer: Array(floatBytes))
				}
			}
		}

		return result
	}

	public func ReadShortData(length: Int) -> [Int16]
	{
		var result = [Int16](repeating: 0, count: length)

		if length > 0 && _inputStream!.hasBytesAvailable
		{
			var buffer = [UInt8](repeating: 0, count: length * 2)
			let bytesRead = _inputStream!.read(&buffer, maxLength: buffer.count) 

			if bytesRead > 0
			{
				for i in 0 ..< length
				{
					let shortBytes = buffer[i*2..<i*2+2]
					result[i] = Converter.ConvertToShort(buffer: Array(shortBytes))
				}
			}
		}

		return result
	}
}
