import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserIdentityController: Sendable {

    func getRemoveUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserIdentityController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/identities/{id}/remove/",
            use: getRemoveUserIdentity
        )
        router.post(
            "/admin/user/identities/{id}/remove/",
            use: postRemoveUserIdentity
        )
    }
}
