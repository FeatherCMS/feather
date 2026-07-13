import Hummingbird

struct AdminNewsletterSubscribersDirectoryDefaultController: AdminNewsletterSubscribersDirectoryController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminNewsletterSubscribersDirectoryInteractor, presenter: AdminNewsletterSubscribersDirectoryDefaultPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch()
        let campaignId = request.queryString("campaignId")?.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            return presenter.render(model: try await interactor.list(search: search, campaignId: campaignId), error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.render(model: .init(items: [], campaigns: [], search: search ?? "", campaignId: campaignId ?? ""), error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }
}
