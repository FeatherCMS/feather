import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetMediaHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/",
            use: getHome
        )
    }
}
