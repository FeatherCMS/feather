import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuPresenter: Sendable {

    func renderListPage(
        model: AdminListWebMenuModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
