import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageMetadataController: Sendable {

    func getEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditWebPageMetadataController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        let path = WebPageRoutes.metadata(
            RouterPath("{id}"),
            RouterPath("{metadataID}")
        )
        router.get(path, use: getEditWebPageMetadata)
        router.post(path, use: postEditWebPageMetadata)
    }
}
