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

extension Asset.File.Edit {
    enum Controller {}
}

extension Asset.File.Edit.Controller {
    protocol Interface: Sendable {
        func getEditMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
