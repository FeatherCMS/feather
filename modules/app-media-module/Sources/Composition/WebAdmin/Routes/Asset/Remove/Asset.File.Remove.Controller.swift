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

extension Asset.File.Remove {
    enum Controller {}
}

extension Asset.File.Remove.Controller {
    protocol Interface: Sendable {

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
