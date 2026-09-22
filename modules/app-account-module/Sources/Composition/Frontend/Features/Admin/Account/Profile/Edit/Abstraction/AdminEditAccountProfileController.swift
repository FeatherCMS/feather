import FeatherAdmin
import Hummingbird

protocol AdminEditAccountProfileController: Sendable {

    func getEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAccountProfileController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.profileEdit.description + "/"),
            use: getEditAccountProfile
        )
        router.post(
            RouterPath(AccountAdminRoutes.profileEdit.description + "/"),
            use: postEditAccountProfile
        )
    }
}
