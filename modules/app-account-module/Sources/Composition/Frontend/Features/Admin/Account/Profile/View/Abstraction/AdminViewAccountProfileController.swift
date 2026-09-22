import FeatherAdmin
import Hummingbird

protocol AdminViewAccountProfileController: Sendable {

    func getAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountProfileController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.profile.description + "/"),
            use: getAccountProfile
        )
    }
}
