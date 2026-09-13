import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityController: Sendable {

    func getUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/identities",
            use: getUserIdentities
        )
    }
}
