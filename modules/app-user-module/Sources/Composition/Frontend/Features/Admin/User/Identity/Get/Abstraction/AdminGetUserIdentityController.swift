import FeatherAdmin
import Hummingbird

protocol AdminGetUserIdentityController: Sendable {

    func getUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

}

extension AdminGetUserIdentityController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/identities/{id}/",
            use: getUserIdentity
        )
    }
}
