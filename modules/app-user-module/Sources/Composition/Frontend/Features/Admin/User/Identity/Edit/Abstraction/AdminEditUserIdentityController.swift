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
            UserIdentityRoutes.edit(RouterPath("{id}")),
            use: getEditUserIdentity
        )
        router.post(
            UserIdentityRoutes.edit(RouterPath("{id}")),
            use: postEditUserIdentity
        )
    }
}
