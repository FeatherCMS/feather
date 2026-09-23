import FeatherAdmin
import Hummingbird

protocol AdminViewAccountProfileController: Sendable {

    func getAccountProfile(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountProfileController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.profile.description + "/"),
            use: getAccountProfile
        )
    }
}
