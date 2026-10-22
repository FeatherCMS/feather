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

extension Asset.File.Add.Controller {
    protocol Interface: Sendable {

        func getAddMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddMediaAsset(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
