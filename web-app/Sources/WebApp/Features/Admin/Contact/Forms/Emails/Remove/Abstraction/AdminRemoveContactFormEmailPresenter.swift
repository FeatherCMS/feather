import Hummingbird

protocol AdminRemoveContactFormEmailPresenter: Sendable {
    func renderPage(
        formId: String,
        mail: AdminContactFormEmail,
        permissions: Set<String>
    ) -> HTMLResponse
}
