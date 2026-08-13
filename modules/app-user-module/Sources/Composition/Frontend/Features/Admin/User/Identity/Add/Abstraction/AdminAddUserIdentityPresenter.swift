import FeatherAdmin
import HTML
import Hummingbird

protocol AdminAddUserIdentityPresenter: Sendable {
    func renderPage(
        form: UserIdentityForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        status: String
    ) -> UserIdentityForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
