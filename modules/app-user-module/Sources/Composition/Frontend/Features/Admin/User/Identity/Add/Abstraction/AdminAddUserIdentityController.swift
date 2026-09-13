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
            RouterPath(UserIdentityRoutes.add.description + "/"),
            use: getAddUserIdentity
        )
        router.post(
            RouterPath(UserIdentityRoutes.add.description + "/"),
            use: postAddUserIdentity
        )
    }
}
