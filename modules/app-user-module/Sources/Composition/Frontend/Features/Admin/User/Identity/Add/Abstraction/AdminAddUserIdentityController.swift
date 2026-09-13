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
            UserIdentityRoutes.add,
            use: getAddUserIdentity
        )
        router.post(
            UserIdentityRoutes.add,
            use: postAddUserIdentity
        )
    }
}
