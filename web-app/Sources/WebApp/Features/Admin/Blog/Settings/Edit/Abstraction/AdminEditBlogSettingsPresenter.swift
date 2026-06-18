protocol AdminEditBlogSettingsPresenter: Sendable {
    func renderPage(
        state: BlogSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
