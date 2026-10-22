import AuthModule
import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension MagicLink.App.Controller {
    protocol Interface: Sendable {
        func getRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse

        func postRequest(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response

        func verify(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}

extension MagicLink.App.Controller.Interface {
    func route(
        on router: any RouterMethods<DefaultRequestContext>,
        routes: MagicLink.App.Router.Routes
    ) {
        router.get(routes.request.routerPath, use: getRequest)
        router.post(routes.request.routerPath, use: postRequest)
        router.get(routes.verify.routerPath, use: verify)
    }
}
