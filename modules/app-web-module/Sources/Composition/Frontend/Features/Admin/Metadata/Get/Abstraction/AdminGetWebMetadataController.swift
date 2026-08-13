import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebMetadataController: Sendable {

    func getWebMetadata(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMetadataController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/metadata/{id}/",
            use: getWebMetadata
        )
    }
}
