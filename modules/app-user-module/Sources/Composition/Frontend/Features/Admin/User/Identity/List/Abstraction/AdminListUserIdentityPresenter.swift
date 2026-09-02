import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityPresenter: Sendable {

    func renderPage(
        state: UserIdentityTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
