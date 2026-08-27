import FeatherAdmin
import Hummingbird

protocol AdminEditUserIdentityController: Sendable {

    func getEditUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
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
