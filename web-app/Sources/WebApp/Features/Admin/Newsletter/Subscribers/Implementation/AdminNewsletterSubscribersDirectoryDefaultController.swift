import Hummingbird

struct AdminNewsletterSubscribersDirectoryDefaultController:
    AdminNewsletterSubscribersDirectoryController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminNewsletterSubscribersDirectoryInteractor,
            presenter: AdminNewsletterSubscribersDirectoryDefaultPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let search = request.querySearch()
        let campaignId = request.queryString("campaignId")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            return presenter.render(
                model: try await interactor.list(
                    search: search,
                    campaignId: campaignId
                ),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                model: .init(
                    items: [],
                    campaigns: [],
                    search: search ?? "",
                    campaignId: campaignId ?? ""
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func bulkRemoveConfirmation(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (_, presenter) = buildRuntime(request, context)
        let emails = request.queryStrings("selectedIds")
        guard !emails.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [.location: "/admin/newsletters/subscribers/"]
            )
        }
        return
            try presenter.renderBulkRemoveConfirmation(
                search: request.querySearch(),
                campaignId: request.queryString("campaignId"),
                emails: emails,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let campaignId = payload.campaignId?.nilIfEmpty
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(
                subscriberIds: payload.normalizedSelectedIds,
                campaignId: campaignId
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/newsletters/subscribers/",
                    title: "Removed",
                    message: "Selected subscribers removed successfully."
                )
            ]
        )
    }
}
