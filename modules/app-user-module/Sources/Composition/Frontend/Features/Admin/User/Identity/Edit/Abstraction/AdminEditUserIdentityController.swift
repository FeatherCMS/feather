import FeatherAdmin
import Hummingbird

protocol AdminEditUserIdentityController: Sendable {

    func getEditUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditUserIdentityController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/identities/{id}/edit/",
            use: getEditUserIdentity
        )
        router.post(
            "/admin/user/identities/{id}/edit/",
            use: postEditUserIdentity
        )
    }
}
