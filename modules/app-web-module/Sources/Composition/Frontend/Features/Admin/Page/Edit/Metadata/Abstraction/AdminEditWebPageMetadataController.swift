import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebPageMetadataController: Sendable {

    func getEditWebPageMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditWebPageMetadata(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditWebPageMetadataController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        let path = WebPageRoutes.metadata(
            RouterPath("{id}"),
            RouterPath("{metadataID}")
        )
        router.get(path, use: getEditWebPageMetadata)
        router.post(path, use: postEditWebPageMetadata)
    }
}
