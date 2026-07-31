import Hummingbird

protocol AdminAddContactFormEmailPresenter: Sendable {
    func renderPage(
        formId: String,
        availableFields: [AdminContactFormFieldOption],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
