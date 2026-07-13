import Hummingbird

struct AdminNewsletterIssueListDefaultController: AdminNewsletterIssueListController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminNewsletterIssueListInteractor, presenter: any AdminNewsletterIssueListPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("id")
        do {
            return presenter.render(newsletterId: newsletterId, items: try await interactor.list(newsletterId: newsletterId), error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.render(newsletterId: newsletterId, items: [], error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }
}
