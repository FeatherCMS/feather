import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout {
    enum Controller {}
}

extension Logout.Controller {
    protocol Interface: Sendable {

        func getLogout(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}

extension Logout.Controller.Interface {
    func route(on router: any RouterMethods<DefaultRequestContext>) {
        router.get(RouterPath("/logout/"), use: getLogout)
    }
}
