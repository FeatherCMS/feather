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

extension Overview.View {
    enum Presenter {}
}

extension Overview.View.Presenter {
    protocol Interface: Sendable {

        func renderOverview(
            model: Overview.View.Model
        ) async throws -> HTMLResponse
    }
}
