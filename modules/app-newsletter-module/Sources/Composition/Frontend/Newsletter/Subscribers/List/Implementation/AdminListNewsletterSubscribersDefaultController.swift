import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterSubscribersDefaultController:
    AdminListNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListNewsletterSubscribersInteractor,
            presenter: any AdminListNewsletterSubscribersPresenter
        )

    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let campaignId = request.queryString("campaignId")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            return presenter.render(
                model: try await interactor.list(
                    search: request.querySearch(),
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
                    search: request.querySearch() ?? "",
                    campaignId: campaignId ?? ""
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
