import FeatherAdmin
import Hummingbird

protocol AdminViewUserIdentityController: Sendable {

    func getUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminViewUserIdentityController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.details(RouterPath("{id}")),
            use: getUserIdentity
        )
    }
}
