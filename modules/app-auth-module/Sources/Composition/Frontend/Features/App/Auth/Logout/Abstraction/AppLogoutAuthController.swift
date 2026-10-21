import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AppLogoutAuthController: Sendable {

    func getLogout(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppLogoutAuthController {

    func route(
        on router: Hummingbird.Router<DefaultRequestContext>
    ) {
        router.get(
            "/logout/",
            use: getLogout
        )
    }
}
