import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Edit.Template {
    enum Presenter {}
}

extension Page.Edit.Template.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Page.Edit.Template.Model
        ) async throws -> HTMLResponse
    }
}
