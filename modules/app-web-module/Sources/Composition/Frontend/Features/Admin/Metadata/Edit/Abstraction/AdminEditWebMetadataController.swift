import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMetadataController: Sendable {

    func getEditWebMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditWebMetadataController {

    func route(
        on router: Router<DefaultRequestContext>
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
