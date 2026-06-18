import Hummingbird

protocol AdminGetMediaAssetController: Sendable {

    func getMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetMediaAssetController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/assets/{id}/",
            use: getMediaAsset
        )
    }
}
