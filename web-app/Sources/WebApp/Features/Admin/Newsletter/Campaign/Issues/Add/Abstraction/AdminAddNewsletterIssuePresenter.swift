import Hummingbird

protocol AdminAddNewsletterIssuePresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterIssueModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
