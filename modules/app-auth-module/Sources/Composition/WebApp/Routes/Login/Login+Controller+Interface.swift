import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Login.Controller {
    protocol Interface: Sendable {

        func getLogin(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse

        func postLogin(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}

extension Login.Controller.Interface {
    func route(on router: any RouterMethods<DefaultRequestContext>) {
        router.get(RouterPath("/login/"), use: getLogin)
        router.post(RouterPath("/login/"), use: postLogin)
    }
}
