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

    func removeConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func remove(
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
            "/admin/media/processors/remove/",
            use: removeConfirmation
        )
        router.post(
            "/admin/media/processors/remove/",
            use: remove
        )
    }
}
