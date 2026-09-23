import FeatherAdmin
import Hummingbird

protocol AdminEditUserIdentityController: Sendable {

    func getEditUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditUserIdentityController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.edit(RouterPath("{id}")),
            use: getEditUserIdentity
        )
        router.post(
            UserIdentityRoutes.edit(RouterPath("{id}")),
            use: postEditUserIdentity
        )
    }
}
