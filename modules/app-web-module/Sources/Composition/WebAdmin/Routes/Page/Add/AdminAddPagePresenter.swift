import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminAddPagePresenter: Sendable {

    func renderAddPage(
        state: PageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
