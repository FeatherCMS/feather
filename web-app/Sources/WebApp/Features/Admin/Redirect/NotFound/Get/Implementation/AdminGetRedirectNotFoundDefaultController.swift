import Foundation
import Hummingbird

struct AdminGetRedirectNotFoundDefaultController:
    AdminGetRedirectNotFoundController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetRedirectNotFoundInteractor,
            presenter: any AdminGetRedirectNotFoundPresenter
        )

    func getNotFound(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminRedirect.Scope.notFound
        )
        if !canAccess {
            return presenter.renderDenied(permissions: permissions)
        }
        let range =
            AdminAnalyticsInsightsPage.Range(
                rawValue: request.queryString("range") ?? ""
            ) ?? .last7Days
        let now = Date()
        let from = now.addingTimeInterval(-range.duration).timeIntervalSince1970
        let to = now.timeIntervalSince1970
        do {
            let overview = try await interactor.getOverview(from: from, to: to)
            return presenter.render(
                model: .init(
                    title: "404s",
                    description: "404 trends and missing routes.",
                    selectedRange: range,
                    overview: overview
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
