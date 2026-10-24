import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Presenter {}
}

extension Invitation.Add.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            form: Invitation.Form.Component.State,
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
