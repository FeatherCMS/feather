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

extension Asset.Folder.Add {
    enum Controller {}
}

extension Asset.Folder.Add.Controller {
    protocol Interface: Sendable {

        func getAddMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
