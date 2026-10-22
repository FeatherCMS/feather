import AccountModule
import FeatherWebAdmin

extension Invitation.List.Presenter {

    protocol Interface: Sendable {

        func renderListPage(
            model: Invitation.List.Model,
            isAdded: Bool,
            isEdited: Bool,
            isRemoved: Bool,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
