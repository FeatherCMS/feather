import FeatherAdmin
import Hummingbird

public protocol AppPublicContentController: Sendable {

    func getContent(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppPublicContentController {

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/", use: getContent)
        router.get("/**", use: getContent)
    }
}
