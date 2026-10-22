import FeatherWebAdmin
import WebDomain
import Hummingbird
import OpenAPIRuntime

extension WebDomain.Menu.Add {
    enum Presenter {}
}

extension WebDomain.Menu.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: MenuForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
