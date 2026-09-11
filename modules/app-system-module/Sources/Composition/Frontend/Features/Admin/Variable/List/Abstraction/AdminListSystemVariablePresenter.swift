import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListSystemVariableModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
