import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveAuthSession(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
    }

    extension Session.Remove.Controller.Interface {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Session.Router.Routes
    ) {
        router.post(
            routes.remove.routerPath,
            use: postRemoveAuthSession
        )
    }
}
