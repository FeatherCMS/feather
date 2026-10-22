import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Overview.View.Presenter {
    protocol Interface: Sendable {

        func renderOverview(
            model: Overview.View.Model
        ) async throws -> HTMLResponse
    }
}
