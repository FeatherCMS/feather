import CSS
import Hummingbird

struct CSSResponse: ResponseGenerator {

    let css: Stylesheet
    let status: HTTPResponse.Status = .ok

    init(
        _ css: Stylesheet
    ) {
        self.css = css
    }

    public func response(
        from request: Request,
        context: some RequestContext
    ) throws -> Response {
        let renderer = StylesheetRenderer(minify: false, indent: 4)
        let cssString = renderer.render(css)
        let buffer = ByteBuffer(string: cssString)
        return .init(
            status: status,
            headers: [
                .contentType: "text/css; charset=utf-8",
                .cacheControl: "no-cache",
                    //                .cacheControl: "max-age=\(60 * 60 * 24 * 30)",
            ],
            body: .init(
                byteBuffer: buffer
            )
        )
    }
}
