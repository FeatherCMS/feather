import Hummingbird

protocol AdminAddMediaFolderController: Sendable {

    func getAddMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddMediaFolderController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/folders/add/",
            use: getAddMediaFolder
        )
        router.post(
            "/admin/media/folders/add/",
            use: postAddMediaFolder
        )
    }
}
