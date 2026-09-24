import FeatherAdmin
import Hummingbird

protocol AdminEditAccountProfileController: Sendable {

    func getEditAccountProfile(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountProfile(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditAccountProfileController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
