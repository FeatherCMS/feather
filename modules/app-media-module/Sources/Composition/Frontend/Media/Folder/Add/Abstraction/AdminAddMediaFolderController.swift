import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaFolderController: Sendable {

    func getAddMediaFolder(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaFolder(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddMediaFolderController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/media/folders/add/",
            use: getAddMediaFolder
        )
        router.post(
            "/admin/media/folders/add/",
            use: postAddMediaFolder
        )
    }
}
