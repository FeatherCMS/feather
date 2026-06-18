import Hummingbird

protocol AdminAddMediaAssetController: Sendable {

    func getAddMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddMediaAssetController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/assets/add/",
            use: getAddMediaAsset
        )
        router.post(
            "/admin/media/assets/add/",
            use: postAddMediaAsset
        )
    }
}
