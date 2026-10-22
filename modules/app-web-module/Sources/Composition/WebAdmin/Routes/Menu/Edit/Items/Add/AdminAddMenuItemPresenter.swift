import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddMenuItemPresenter: Sendable {

    func renderAddPage(
        menuId: String,
        state: MenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
