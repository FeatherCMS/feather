import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddMediaFolderController: Sendable {

    func getAddMediaFolder(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaFolder(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddMediaFolderController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
