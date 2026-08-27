import FeatherAdmin
import Hummingbird

protocol AdminEditAccountProfileController: Sendable {
    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func post(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAccountProfileController {
    func route(on router: Router<DefaultRequestContext>) {
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
