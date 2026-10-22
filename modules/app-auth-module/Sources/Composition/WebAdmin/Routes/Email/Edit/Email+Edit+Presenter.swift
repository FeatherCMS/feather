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

extension Email.Edit {
    enum Presenter {}
}

extension Email.Edit.Presenter {
    protocol Interface: Sendable {

        func formState(
            identityId: String,
            identities: [Credential.Form.IdentityOption],
            email: String
        ) -> Email.Form.Component.State

        func renderPage(
            id: String,
            isEdited: Bool,
            form: Email.Form.Component.State,
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

extension Email.Edit.Presenter.Interface {
    func formState(
        identityId: String,
        email: String = ""
    ) -> Email.Form.Component.State {
        formState(identityId: identityId, identities: [], email: email)
    }
}
