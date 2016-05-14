import Foundation

public class Converter
{
	public class func ConvertToInt32(buffer: [UInt8]) -> Int32
	{
		if buffer.count != 4
		{
			//TODO throw exception
		}

		var value : Int32 = 0
		let data = NSData(bytes: buffer, length: 4)
		data.getBytes(&value, length: 4)
		value = Int32(bigEndian: value)

		return value
	}

	public class func ConvertToInt(buffer: [UInt8]) -> Int
	{
		if buffer.count != 4 || buffer.count != 8
		{
			//throw
		}

		var value = 0
		let data = NSData(bytes: buffer, length: buffer.count)
		data.getBytes(&value, length: buffer.count)
		return Int(bigEndian: value)
	}

	public class func ConvertToSingle(buffer: [UInt8]) -> Float
	{
		if buffer.count != 4
		{
			//TODO throw exception
		}

		var value : Float = 0.0
		let data = NSData(bytes: buffer, length: 4)
		data.getBytes(&value, length: 4)
		value = Float(bigEndian: value)

		return value
	}

	public class func ConvertToShort(buffer: [UInt8]) -> Int16
	{
		if buffer.count != 2
		{
			//TODO throw exception
		}

		var value : Int16 = 0
		let data = NSData(bytes: buffer, length: 2)
		data.getBytes(&value, length: 2)
		value = Int16(bigEndian: value)

		return value
	}

	public class func AnyToByteArray<T> (value: T) -> [UInt8]
	{
		var val = value
	    return withUnsafePointer(&val)
	    {
	        Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
	    }
	}
}