import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListMediaProcessorController: Sendable {

    func getListMediaProcessors(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func bulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func bulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListMediaProcessorController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/media/processors/",
            use: getListMediaProcessors
        )
        router.get(
            "/admin/media/processors/bulk-remove/",
            use: bulkRemoveConfirmation
        )
        router.post(
            "/admin/media/processors/bulk-remove/",
            use: bulkRemove
        )
    }
}
