import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Detail.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Detail.Interactor.Interface,
                any Campaign.Detail.Presenter.Interface
            >

        func get(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let campaignId = try context.requiredParameter("newsletterId")
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.read)
            else {
                return try await runtime.presenter.render(
                    id: campaignId,
                    item: .init(id: campaignId, name: "", fromEmail: ""),
                    error: "Your account cannot view newsletter campaigns.",
                    permissions: context.currentUserPermissions
                )
            }

            do {
                return try await runtime.presenter.render(
                    id: campaignId,
                    item: try await runtime.interactor.get(id: campaignId),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await runtime.presenter.render(
                    id: campaignId,
                    item: .init(id: campaignId, name: "", fromEmail: ""),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }
    }
}
