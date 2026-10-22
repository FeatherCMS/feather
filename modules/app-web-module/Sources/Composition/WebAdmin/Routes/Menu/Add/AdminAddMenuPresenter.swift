import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddMenuPresenter: Sendable {

    func renderAddPage(
        state: MenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
