import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add {
    enum Presenter {}
}

extension WebModule.Menu.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: MenuForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
