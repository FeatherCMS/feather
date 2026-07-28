import Hummingbird

protocol AdminRemoveNewsletterIssuePresenter: Sendable {
    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        -> HTMLResponse
}
