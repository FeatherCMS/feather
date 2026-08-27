import FeatherAdmin
import Hummingbird

protocol AdminEditAccountProfileController: Sendable {
    func get(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func post(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAccountProfileController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/account/users/{userId}/profile/",
            use: get
        )
        router.post(
            "/admin/account/users/{userId}/profile/",
            use: post
        )
    }
}
