import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit {
    enum Controller {}
}

extension Asset.Folder.Edit.Controller {
    protocol Interface: Sendable {

        func getEditMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
