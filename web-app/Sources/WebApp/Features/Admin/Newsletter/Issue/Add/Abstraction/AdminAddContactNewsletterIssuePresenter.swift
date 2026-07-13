import Hummingbird
protocol AdminAddContactNewsletterIssuePresenter: Sendable {
    func renderPage(model: AdminAddContactNewsletterIssueModel, permissions: Set<String>) -> HTMLResponse
}
