public enum ResultCode : Int
{
	case Success, Failure, Continue
}

public class ResultType
{
	public var first: ResultCode = ResultCode.Failure
	public var second: String = ""
}

public class LuaConsole
{
	public class func SendChunk(client: Client, chunk: String, timeOutSecond: Int) -> ResultType
	{
		let resultType = ResultType()

		if client.writeData(chunk, timeOutSecond)
		{
			let response = client.readData(timeOutSecond)

			if response.count > 0
			{
				let code = Int(response[0])

				if code >= ResultCode.Success && code <= ResultCode.Continue
				{
					resultType.first = ResultCode(code)
				}

				if response.count > 1
				{
					let resp [UInt8] = response[1..<response.count]
					resultType.second = String(data: resp, encoding: NSUTF8StringEncoding) 
				}

			}
		}

		return resultType
	}

	public class func SendChunk(client: Client, chunk: String) -> ResultType
	{
		SendChunk(client, chunk, -1)
	}
}