public import FeatherAdmin
public import Hummingbird

public protocol AppPublicContentController: Sendable {

    func getRSS(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func getSitemap(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func getContent(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppPublicContentController {

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/rss.xml", use: getRSS)
        router.get("/sitemap.xml", use: getSitemap)
        router.get("/", use: getContent)
        router.get("/**", use: getContent)
    }
}
