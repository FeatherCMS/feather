import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveMediaProcessorController: Sendable {

    func getRemoveMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaProcessorController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/media/processors/{id}/remove/",
            use: getRemoveMediaProcessor
        )
        router.post(
            "/admin/media/processors/{id}/remove/",
            use: postRemoveMediaProcessor
        )
    }
}
