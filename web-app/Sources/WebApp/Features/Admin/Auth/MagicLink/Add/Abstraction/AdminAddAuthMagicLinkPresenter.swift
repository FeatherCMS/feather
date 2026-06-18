import Foundation

protocol AdminAddAuthMagicLinkPresenter: Sendable {

    func renderPage(
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String,
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
