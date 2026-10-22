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

extension Asset.File.List.Controller {
    protocol Interface: Sendable {

        func getListMediaAssets(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
