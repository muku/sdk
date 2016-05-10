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

	public class func AnyToByteArray<T> (var value: T) -> [UInt8]
	{
	    return withUnsafePointer(&value)
	    {
	        Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
	    }
	}
}