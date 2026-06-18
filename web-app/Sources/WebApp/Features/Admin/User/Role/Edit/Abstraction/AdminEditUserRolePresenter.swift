import Foundation
import Hummingbird

protocol AdminEditUserRolePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: UserRoleForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        name: String,
        notes: String
    ) -> UserRoleForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
