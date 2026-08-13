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
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
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
