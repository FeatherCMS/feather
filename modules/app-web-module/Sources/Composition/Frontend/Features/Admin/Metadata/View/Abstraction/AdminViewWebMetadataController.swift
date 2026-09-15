import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebMetadataController: Sendable {

    func getWebMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebMetadataController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/metadata/{id}/",
            use: getWebMetadata
        )
    }
}
