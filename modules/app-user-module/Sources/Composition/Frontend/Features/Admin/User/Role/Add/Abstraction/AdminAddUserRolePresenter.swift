import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminAddUserRolePresenter: Sendable {

    func renderPage(
        form: UserRoleForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        id: String,
        name: String,
        notes: String
    ) -> UserRoleForm.State

    func breadcrumb() -> AdminBreadcrumb.State
    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
