import Foundation

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

		if client.writeData(message: chunk, timeOutSecond: timeOutSecond)
		{
			let response = client.readData(timeOutSecond: timeOutSecond)

			if response.count > 0
			{
				let code = Int(response[0])

				if code >= ResultCode.Success.rawValue && code <= ResultCode.Continue.rawValue
				{
					resultType.first = ResultCode(rawValue: code)!
				}

				if response.count > 1
				{
					let nsData = NSData(bytes: response, length: response.count)
					resultType.second = String(data: nsData, encoding: NSUTF8StringEncoding)! 
				}

			}
		}

		return resultType
	}

	public class func SendChunk(client: Client, chunk: String) -> ResultType
	{
		return SendChunk(client: client, chunk: chunk, timeOutSecond: -1)
	}
}