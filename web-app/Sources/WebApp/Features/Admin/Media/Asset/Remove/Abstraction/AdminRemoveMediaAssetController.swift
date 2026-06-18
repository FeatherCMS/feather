import Hummingbird

protocol AdminRemoveMediaAssetController: Sendable {

    func getRemoveMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaAssetController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/assets/{id}/remove/",
            use: getRemoveMediaAsset
        )
        router.post(
            "/admin/media/assets/{id}/remove/",
            use: postRemoveMediaAsset
        )
    }
}
