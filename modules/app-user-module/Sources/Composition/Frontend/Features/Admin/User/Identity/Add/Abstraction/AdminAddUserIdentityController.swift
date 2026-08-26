import FeatherAdmin
import HTML
import Hummingbird

protocol AdminAddUserIdentityController: Sendable {

    func getAddUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
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
