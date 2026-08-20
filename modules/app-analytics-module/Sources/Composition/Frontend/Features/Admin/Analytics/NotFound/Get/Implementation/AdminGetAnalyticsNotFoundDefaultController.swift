import AnalyticsContracts
import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetAnalyticsNotFoundDefaultController:
    AdminGetAnalyticsNotFoundController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetAnalyticsNotFoundInteractor,
            presenter: any AdminGetAnalyticsNotFoundPresenter
        )

    func getNotFound(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: AnalyticsPermissions.NotFound.list
        )
        if !canAccess {
            return presenter.renderDenied(permissions: permissions)
        }
        let range =
            AdminAnalyticsNotFoundRange(
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
