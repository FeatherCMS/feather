import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Add {
    enum Presenter {}
}

extension MenuItem.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(
            menuId: String,
            state: MenuItemForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
