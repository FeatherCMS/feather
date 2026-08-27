import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaProcessorController: Sendable {

    func getAddMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddMediaProcessorController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/media/processors/add/",
            use: getAddMediaProcessor
        )
        router.post(
            "/admin/media/processors/add/",
            use: postAddMediaProcessor
        )
    }
}
