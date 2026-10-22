import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout.Controller {
    protocol Interface: Sendable {

        func getLogout(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}

extension Logout.Controller.Interface {

    func route(
        on router: Hummingbird.Router<DefaultRequestContext>
    ) {
        router.get(
            "/logout/",
            use: getLogout
        )
    }
}
