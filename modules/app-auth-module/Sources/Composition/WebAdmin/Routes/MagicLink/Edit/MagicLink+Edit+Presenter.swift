import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension MagicLink.Edit {
    enum Presenter {}
}

extension MagicLink.Edit.Presenter {
    protocol Interface: Sendable {

        func formState(
            credentialId: String,
            emails: [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail],
            isPersistent: Bool
        ) -> MagicLink.Add.Form.State

        func renderPage(
            id: String,
            isEdited: Bool,
            form: MagicLink.Add.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func format(
            error: OpenAPIRepositoryError
        ) -> String
    }
}

extension MagicLink.Edit.Presenter.Interface {
    func formState(
        credentialId: String,
        isPersistent: Bool
    ) -> MagicLink.Add.Form.State {
        formState(
            credentialId: credentialId,
            emails: [],
            isPersistent: isPersistent
        )
    }
}
