import FeatherAdmin
import Hummingbird

protocol AdminViewUserIdentityController: Sendable {

    func getUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminViewUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.details(RouterPath("{id}")),
            use: getUserIdentity
        )
    }
}
