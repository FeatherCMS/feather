import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Add {
    enum Presenter {}
}

extension Page.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: Page.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
