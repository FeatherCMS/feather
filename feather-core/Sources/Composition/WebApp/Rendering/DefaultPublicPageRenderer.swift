import CSS
public import FeatherWebShared
public import HTML
public import Hummingbird
import NIOCore
import SGML
import WebBuilders
public import WebComponents

public struct DefaultPublicPageRenderer: PublicPageRenderer {
    public let publicOrigins: AppPublicOriginConfiguration

    public init(publicOrigins: AppPublicOriginConfiguration) {
        self.publicOrigins = publicOrigins
    }

    public func render<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> Response where T.HTML: FlowContent {
        var context = BuilderContext()
        let contentHTML = context.build(content)
        let cssRenderer = CSSRenderer(minify: false, indent: 4)
        let css = cssRenderer.render(context.stylesheet())
        let scripts = context.scripts()
        let canonicalURL = normalizedURL(
            base: publicOrigins.siteBaseURL,
            path: request.uri.path
        )
        let imageURL = normalizedURL(
            base: publicOrigins.staticBaseURL,
            path: imagePath
        )
        var metadata: [any MetadataContent] = [
            Meta().charset("utf-8"),
            Meta().name(.viewport)
                .content("width=device-width, initial-scale=1"),
            Link(rel: .canonical).href(canonicalURL),
            Title(title),
            Meta().name(.description).content(description),
            Meta().property("og:url").content(canonicalURL),
            Meta().property("og:title").content(title),
            Meta().property("og:description").content(description),
            Meta().property("og:image").content(imageURL),
            Meta().name("twitter:card").content("summary_large_image"),
            Meta().name("twitter:url").content(canonicalURL),
            Meta().name("twitter:title").content(title),
            Meta().name("twitter:description").content(description),
            Meta().name("twitter:image").content(imageURL),
        ]
        if !css.isEmpty {
            metadata.append(Style(css))
        }
        for script in scripts where !script.isEmpty {
            metadata.append(Script(script))
        }
        let html = Html {
            Head(elements: metadata)
            Body {
                contentHTML
            }
        }
        .lang("en-US")
        let document = Document(type: .html, root: html)
        #if DEBUG
        let rendered = document.render(indent: 4)
        #else
        let rendered = document.render(indent: 0)
        #endif
        return Response(
            status: .ok,
            headers: [.contentType: "text/html; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: rendered))
        )
    }

    private func normalizedURL(
        base: String,
        path: String
    ) -> String {
        var url = base
        if !url.hasSuffix("/") { url += "/" }
        let normalizedPath = path.hasPrefix("/")
            ? String(path.dropFirst())
            : path
        if normalizedPath.isEmpty { return url }
        url += normalizedPath
        if normalizedPath.contains(".") { return url }
        if !url.hasSuffix("/") { url += "/" }
        return url
    }
}
