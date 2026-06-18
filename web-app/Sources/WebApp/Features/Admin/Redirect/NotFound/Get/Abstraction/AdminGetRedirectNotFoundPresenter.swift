protocol AdminGetRedirectNotFoundPresenter: Sendable {

    func render(
        model: AdminGetRedirectNotFoundModel,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDenied(
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
