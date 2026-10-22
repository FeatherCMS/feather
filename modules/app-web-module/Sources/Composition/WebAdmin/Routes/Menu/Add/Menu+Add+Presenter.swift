import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Add {
    enum Presenter {}
}

extension Menu.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: MenuForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
