import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersDefaultController:
    AdminRemoveNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterSubscribersInteractor,
            presenter: any AdminRemoveNewsletterSubscribersPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return try await presenter.render(
            ids: request.queryStrings("selectedIds"),
            search: request.querySearch(),
            campaignId: request.queryString("campaignId"),
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        try await interactor.remove(
            ids: payload.normalizedSelectedIds,
            campaignId: payload.campaignId?.emptyToNil
        )
        return AdminNotificationFlash.redirect(
            to: NewAdminLocation.url(
                path: NewsletterAdminRoutes.subscribers.description,
                queryItems: payload.campaignId?.emptyToNil
                    .map { [("campaignId", $0)] } ?? []
            ),
            notification: .init(
                title: "Removed",
                message: "Selected subscribers removed successfully."
            )
        )
    }
}
