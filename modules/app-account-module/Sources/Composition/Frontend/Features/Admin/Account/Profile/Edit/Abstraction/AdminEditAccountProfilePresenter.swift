import FeatherAdmin
import Hummingbird

protocol AdminEditAccountProfilePresenter: Sendable {
    func render(
        userID: String,
        model: AdminEditAccountProfileModel,
        canEdit: Bool,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        userID: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
