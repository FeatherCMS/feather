public import Hummingbird
import NIOCore

public struct WebAppHTMLResponse: ResponseGenerator {
    public let content: String
    public let status: HTTPResponse.Status
    public let cookies: [Cookie]

    public init(
        content: String,
        status: HTTPResponse.Status = .ok,
        cookies: [Cookie] = []
    ) {
        self.content = content
        self.status = status
        self.cookies = cookies
    }

    public func response(
        from request: Request,
        context: some RequestContext
    ) throws -> Response {
        let buffer = ByteBuffer(string: content)
        var headers: HTTPFields = [
            .contentType: "text/html; charset=utf-8"
        ]
        for cookie in cookies {
            headers[values: .setCookie].append(cookie.description)
        }
        #if DEBUG
        headers[.cacheControl] = "no-cache"
        #endif
        return .init(
            status: status,
            headers: headers,
            body: .init(byteBuffer: buffer)
        )
    }
}
