import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}

extension Session.List.Controller.Interface {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Session.Router.Routes
    ) {
        router.get(
            routes.list.routerPath,
            use: get
        )
    }
}
