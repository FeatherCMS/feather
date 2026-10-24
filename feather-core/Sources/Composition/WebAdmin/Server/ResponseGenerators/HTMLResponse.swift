public import HTML
public import Hummingbird
import SGML

public struct HTMLResponse: ResponseGenerator {
    public let content: String
    public let status: HTTPResponse.Status
    public let cookies: [Cookie]

    public init(
        _ html: Html,
        status: HTTPResponse.Status = .ok,
        cookies: [Cookie] = []
    ) {
        let document = Document(type: .html, root: html)
        #if DEBUG
        self.content = document.render(indent: 4)
        #else
        self.content = document.render(indent: 0)
        #endif
        self.status = status
        self.cookies = cookies
    }

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
        var responseCookies = cookies
        if request.cookies[AdminNotificationFlash.cookieName] != nil {
            responseCookies.append(AdminNotificationFlash.clearCookie())
        }
        for cookie in responseCookies {
            headers[values: .setCookie].append(cookie.description)
        }
        #if DEBUG
        headers[.cacheControl] = "no-cache"
        #endif
        return .init(
            status: status,
            headers: headers,
            body: .init(
                byteBuffer: buffer
            )
        )
    }
}
