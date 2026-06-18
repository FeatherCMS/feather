import Hummingbird

protocol AdminEditAuthAccessControlController: Sendable {

    func getAuthAccessControl(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAuthAccessControl(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAuthAccessControlController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/access-control/",
            use: getAuthAccessControl
        )
        router.post(
            "/admin/auth/access-control/",
            use: postAuthAccessControl
        )
    }
}
