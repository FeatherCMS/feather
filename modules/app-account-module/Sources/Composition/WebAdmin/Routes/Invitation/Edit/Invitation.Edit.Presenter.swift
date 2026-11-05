import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit {
    enum Presenter {}
}

extension Invitation.Edit.Presenter {

    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: Invitation.Form.Component.State,
            isEdited: Bool,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func formState(
            email: String,
            roleIDs: [String],
            roleOptions: [Invitation.Form.Component.RoleOptionState]
        ) -> Invitation.Form.Component.State

        func format(
            error: OpenAPIRepositoryError
        ) -> String
    }
}
