import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityController: Sendable {

    func getUserIdentities(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListUserIdentityController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.list,
            use: getUserIdentities
        )
    }
}
