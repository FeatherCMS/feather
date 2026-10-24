import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebModule

extension WebModule.Metadata.Edit {
    enum Presenter {}
}

extension WebModule.Metadata.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: WebModule.Metadata.Edit.Form.Component.State,
            permissions: Set<String>,
            navigationTabs: [AdminTabBar.Link],
            configuration: WebModule.Metadata.Edit.Configuration
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>,
            configuration: WebModule.Metadata.Edit.Configuration
        ) async throws -> HTMLResponse

    }
}
