import Hummingbird

protocol AdminListWebMetadataController: Sendable {

    func getMetadataEntries(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListWebMetadataController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/metadata",
            use: getMetadataEntries
        )
    }
}
