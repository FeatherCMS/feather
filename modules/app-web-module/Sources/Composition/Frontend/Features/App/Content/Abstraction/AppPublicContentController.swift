import FeatherAdmin
import Hummingbird

public protocol AppPublicContentController: Sendable {

    func getContent(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppPublicContentController {

    public func route(
        on router: Router<AppRequestContext>
    ) {
        router.get("/", use: getContent)
        router.get("/**", use: getContent)
    }
}
