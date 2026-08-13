import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaProcessorController: Sendable {

    func getEditMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/processors/{id}/edit/",
            use: getEditMediaProcessor
        )
        router.post(
            "/admin/media/processors/{id}/edit/",
            use: postEditMediaProcessor
        )
    }
}
