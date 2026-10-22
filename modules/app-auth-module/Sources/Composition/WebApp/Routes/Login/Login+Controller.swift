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

    func route(
        on router: Hummingbird.Router<DefaultRequestContext>
    ) {
        router.get(
            "/login/",
            use: getLogin
        )
        router.post(
            "/login/",
            use: postLogin
        )
    }
}
