import Hummingbird

protocol AdminListMediaAssetController: Sendable {

    func getListMediaAssets(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func bulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func bulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func deleteFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListMediaAssetController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/assets/",
            use: getListMediaAssets
        )
        router.get(
            "/admin/media/assets/bulk-remove/",
            use: bulkRemoveConfirmation
        )
        router.post(
            "/admin/media/assets/bulk-remove/",
            use: bulkRemove
        )
        router.post(
            "/admin/media/assets/folders/{id}/remove/",
            use: deleteFolder
        )
    }
}
