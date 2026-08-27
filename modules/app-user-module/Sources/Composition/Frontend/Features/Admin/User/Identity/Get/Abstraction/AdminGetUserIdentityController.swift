import FeatherAdmin
import Hummingbird

protocol AdminGetUserIdentityController: Sendable {

    func getUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminGetUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/identities/{id}/",
            use: getUserIdentity
        )
    }
}
