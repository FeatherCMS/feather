import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminListAccountInvitationPresenter: Sendable {

    func renderListPage(
        model: AdminListAccountInvitationModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse

    func errorState(
        error: OpenAPIRepositoryError
    ) -> AccountInvitationError.State
}
