import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuItemPresenter: Sendable {

    func renderAddPage(
        menuId: String,
        state: WebMenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
