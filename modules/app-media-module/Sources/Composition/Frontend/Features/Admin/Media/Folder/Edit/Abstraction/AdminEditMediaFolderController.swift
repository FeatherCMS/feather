import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditMediaFolderController: Sendable {

    func getEditMediaFolder(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaFolder(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditMediaFolderController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
