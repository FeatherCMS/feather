import FeatherAdmin
import Hummingbird

protocol AdminAddUserIdentityController: Sendable {

    func getAddUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddUserIdentityController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.add,
            use: getAddUserIdentity
        )
        router.post(
            UserIdentityRoutes.add,
            use: postAddUserIdentity
        )
    }
}
