import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMetadataController: Sendable {

    func getMetadataEntries(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListWebMetadataController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/metadata",
            use: getMetadataEntries
        )
    }
}
