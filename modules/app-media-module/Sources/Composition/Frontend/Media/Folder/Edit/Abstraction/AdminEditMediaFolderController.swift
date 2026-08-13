import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaFolderController: Sendable {

    func getEditMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditMediaFolderController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/folders/{id}/edit/",
            use: getEditMediaFolder
        )
        router.post(
            "/admin/media/folders/{id}/edit/",
            use: postEditMediaFolder
        )
    }
}
