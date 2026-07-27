import HTML
import Hummingbird
import SGML

struct HTMLResponse: ResponseGenerator {
    let content: String
    let status: HTTPResponse.Status

    init(
        _ html: Html,
        status: HTTPResponse.Status = .ok
    ) {
        let document = Document(type: .html, root: html)
        self.content = document.render(indent: 4)
        self.status = status
    }

    init(
        content: String,
        status: HTTPResponse.Status = .ok
    ) {
        self.content = content
        self.status = status
    }

    public func response(
        from request: Request,
        context: some RequestContext
    ) throws -> Response {
        let buffer = ByteBuffer(string: content)
        var headers: HTTPFields = [
            .contentType: "text/html; charset=utf-8",
        ]
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
