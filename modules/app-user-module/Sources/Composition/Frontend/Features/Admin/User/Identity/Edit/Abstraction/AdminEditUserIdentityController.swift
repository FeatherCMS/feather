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
            RouterPath(UserIdentityRoutes.editPattern.description + "/"),
            use: getEditUserIdentity
        )
        router.post(
            RouterPath(UserIdentityRoutes.editPattern.description + "/"),
            use: postEditUserIdentity
        )
    }
}
