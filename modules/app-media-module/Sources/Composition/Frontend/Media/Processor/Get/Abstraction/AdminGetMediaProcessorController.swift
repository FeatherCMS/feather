import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaProcessorController: Sendable {

    func getMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/processors/{id}/",
            use: getMediaProcessor
        )
    }
}
