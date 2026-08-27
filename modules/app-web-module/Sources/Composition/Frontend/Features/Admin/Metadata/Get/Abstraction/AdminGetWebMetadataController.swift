import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebMetadataController: Sendable {

    func getWebMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMetadataController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/metadata/{id}/",
            use: getWebMetadata
        )
    }
}
