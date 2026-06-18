import HTML
import Hummingbird

protocol AdminAddUserAccountPresenter: Sendable {
    func renderPage(
        form: UserAccountForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String
    ) -> UserAccountForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
