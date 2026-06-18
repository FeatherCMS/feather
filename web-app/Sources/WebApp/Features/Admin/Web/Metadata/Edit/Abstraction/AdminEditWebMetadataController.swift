import HTML
import Hummingbird

protocol AdminEditWebMetadataController: Sendable {

    func getEditWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditWebMetadataController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/metadata/{id}/edit/",
            use: getEditWebMetadata
        )
        router.post(
            "/admin/web/metadata/{id}/edit/",
            use: postEditWebMetadata
        )
    }
}
