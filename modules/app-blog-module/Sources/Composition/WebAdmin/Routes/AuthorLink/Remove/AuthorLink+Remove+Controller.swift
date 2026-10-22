import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink {
    enum Remove {}
}

extension AuthorLink.Remove {
    enum Controller {}
}

extension AuthorLink.Remove.Controller {
    protocol Interface: Sendable {
        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
