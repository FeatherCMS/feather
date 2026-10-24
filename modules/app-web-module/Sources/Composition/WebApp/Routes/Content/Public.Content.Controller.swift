import FeatherWebShared
import Hummingbird

extension Public.Content {
    enum Controller {}
}

extension Public.Content.Controller {
    protocol Interface: Sendable {
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
}
