import FeatherAdmin
import HTML
import Hummingbird

protocol AdminAddUserIdentityController: Sendable {

    func getAddUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddUserIdentityController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/identities/add/",
            use: getAddUserIdentity
        )
        router.post(
            "/admin/user/identities/add/",
            use: postAddUserIdentity
        )
    }
}
