public class Element<T>
{
	private var _data: [T]? = nil

	init(data: [T], length: Int)
	{
		if data.count == length || length == 0
		{
			_data = data
		}
	}

	private func getData(start: Int, length: Int) -> [T]
	{
		var result = [T]()

		if _data != nil && _data!.count > start + length
		{
			var count : Int = 0
			for i in start...start+length
			{
				result[count] = _data![i]
				count++
			}
		}

		return result
	}

	public func access() -> [T]
	{
		return _data!
	}
}

public class ConfigurableElement: Element<Float>
{
	public class let Length: Int = 0

	init(data: [Float])
	{
		super.init(data: data, length: Length)
	}

	public func value(index: Int) -> Float
	{
		return access()[index]
	}

	public func size() -> Int
	{
		return access().count
	}

	public func getRange(start: Int, length: Int) -> [Float]
	{
		return getData(start, length: length)
	}
}

public class PreviewElement: Element<Float>
{
	public class let Length: Int = 4 * 2 + 3 * 2

	init(data: [Float])
	{
		super.init(data: data, length: Length)
	}

	public func getEuler() -> [Float]
	{
		return getData(start: 8, length: 3)
	}

	public func getMatrix(local: Bool) -> [Float]
	{
		return quaternion_to_R3_rotation(getQuaternion(local))
	}

	public func getQuaternion(local: Bool) -> [Float]
	{
		return local ? getData(start: 4, length: 4) : getData(start: 0, length: 4)
	}

	public func getAccelerate() -> [Float]
	{
		return getData(start: 11, length: 3)
	}

	private func quaternion_to_R3_rotation(q: [Float]) -> [Float]
	{
		if q.count != 4
		{
			//throw an exception
		}

		let a = q[0]
        let b = q[1]
        let c = q[2]
        let d = q[3]

        let aa = a * a
        let ab = a * b
        let ac = a * c
        let ad = a * d
        let bb = b * b
        let bc = b * c
        let bd = b * d
        let cc = c * c
        let cd = c * d
        let dd = d * d

        let norme_carre = aa + bb + cc + dd

        // Defaults to the identity matrix.
        var result = [Float](count: 16, repeatedValue: 0.0)
        
        for i in 0...4
        {
          result[4 * i + i] = 1.0
        }

        if norme_carre > 1e-6
        {
        	result[0] = (aa + bb - cc - dd) / norme_carre
         	result[1] = 2 * (-ad + bc) / norme_carre
          	result[2] = 2 * (ac + bd) / norme_carre
          	result[4] = 2 * (ad + bc) / norme_carre
          	result[5] = (aa - bb + cc - dd) / norme_carre
          	result[6] = 2 * (-ab + cd) / norme_carre
          	result[8] = 2 * (-ac + bd) / norme_carre
          	result[9] = 2 * (ab + cd) / norme_carre
          	result[10] = (aa - bb - cc + dd) / norme_carre
        }

        return result
	}
}

public class SensorElement: Element<Float>
{
	public class let Length = 3*3

	init(data: [Float])
	{
		super.init(data: data, length: Length)
	}

	public func getAccelerometer() -> [Float]
	{
		return getData(start: 0, length: 3)
	}

	public func getGyroscope() -> [Float]
	{
		return getData(start: 6, length: 3)
	}

	public func getMagnetometer() -> [Float]
	{
		return getData(start: 3, length: 3)
	}
}

public class RawElement: Element<UInt16>
{
	public class let Length = 3*3

	init(data: [UInt16])
	{
		super.init(data: data, length: Length)
	}

	public func getAccelerometer() -> [UInt16]
	{
		return getData(start: 0, length: 3)
	}

	public func getGyroscope() -> [UInt16]
	{
		return getData(start: 6, length: 3)
	}

	public func getMagnetometer() -> [UInt16]
	{
		return getData(start: 3, length: 3)
	}
}

public class Format
{
	public class func Configurable(data: [UInt8]) -> [Int: ConfigurableElement]
	{
		var result = [Int: ConfigurableElement]()
		let map = IdToFloatArray(buffer: data, length: ConfigurableElement.Length)

		if map.count > 0
		{
			for i in 0..<map.count
			{
				result[i] = ConfigurableElement(map[i])
			}

			if map.count != result.count
			{
				result.removeAll()
			}

			if result.count <= 0
			{
				//TODO throw an exception
			}
		}

		return result
	}

	public class func Preview(data: [UInt8]) -> [Int: PreviewElement]
	{
		var result = [Int: ConfigurableElement]()
		let map = IdToFloatArray(buffer: data, length: PreviewElement.Length)

		if map.count > 0
		{
			for i in 0..<map.count
			{
				result[i] = PreviewElement(map[i])
			}

			if map.count != result.count
			{
				result.removeAll()
			}

			if result.count <= 0
			{
				//TODO throw an exception
			}
		}

		return result
	}

	public class func Sensor(data: [UInt8]) -> [Int: SensorElement]
	{
		var result = [Int: ConfigurableElement]()
		let map = IdToFloatArray(buffer: data, length: SensorElement.Length)

		if map.count > 0
		{
			for i in 0..<map.count
			{
				result[i] = SensorElement(data: map[i])
			}

			if map.count != result.count
			{
				result.removeAll()
			}

			if result.count <= 0
			{
				//TODO throw an exception
			}
		}

		return result
	}

	public class func Raw(data: [UInt8]) -> [Int: RawElement]
	{
		var result = [Int: ConfigurableElement]()
		let map = IdToShortArray(buffer: data, length: RawElement.Length)

		if map.count > 0
		{
			for i in 0..<map.count
			{
				result[i] = RawElement(data: map[i])
			}

			if map.count != result.count
			{
				result.removeAll()
			}

			if result.count <= 0
			{
				//TODO throw an exception
			}
		}

		return result
	}

	private class func IdToFloatArray(buffer: [UInt8], length: Int) -> [Int: [Float]]
	{
		var result = [Int: [Float]]()

		var itr = 0

		while itr < buffer.count && buffer.count - itr > sizeof(Int32)
		{
			var bytes = buffer[itr..<itr+4]
			let key = Converter.ConvertToInt32(buffer: Array(bytes))
			itr += 4

			var elementLength = Int32(length)

			if elementLength > 0 && buffer.count - itr >= elementLength * sizeof(Int32)
			{
				bytes = buffer[itr..<itr+4]
				elementLength = Converter.ConvertToInt32(buffer: Array(bytes))
				itr += 4
			}

			if elementLength > 0 && buffer.count - itr >= elementLength * sizeof(Float)
			{
				let value = [Float](count: elementLength, repeatedValue: 0)

				for i in 0..<elementLength
				{
					bytes = buffer[itr..<itr+4]
					value[i] = Converter.ConvertToSingle(buffer: Array(bytes))
					itr += 4
				}

				result[key] = value
			}
		}

		if itr != buffer.count
		{
			result.removeAll()
		}

		if(result.count == 0)
		{
			//TODO throw exception
		}

		return result
	}

	private class func IdToShortArray(buffer: [UInt8], length: Int) -> [Int: [Int16]]
	{
		var result = [Int: [Int16]]()

		//size of int32 + size of int16 * length
		let elementSize = 4 + 2 * length

		var itr = 0

		while itr < buffer.count && elementSize <= buffer.count - itr
		{
			var bytes = buffer[itr..<itr+4]
			let key = Converter.ConvertToInt32(buffer: Array(bytes))
			itr += 4

			var value = [UInt16](repeating: 0, count: length)

			for i in 0..<length
			{
				bytes = buffer[itr..<itr+2]
				value[i] = Converter.ConvertToShort(buffer: Array(bytes))
				itr += 2
			}

			result[key] = value
		}

		if itr != buffer.count
		{
			result.removeAll()
		}

		if(result.count == 0)
		{
			//TODO throw exception
		}

		return result
	}
}