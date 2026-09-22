import AnalyticsContracts
import FeatherAdmin
import Foundation
import Hummingbird

struct AdminViewAnalyticsInsightsDefaultController:
    AdminViewAnalyticsInsightsController
{
    let source: AdminAnalyticsInsightsPage.Source
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAnalyticsInsightsInteractor,
            presenter: any AdminViewAnalyticsInsightsPresenter
        )

    func getInsights(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: AnalyticsPermissions.Insights.list
        )
        if !canAccess {
            return try await presenter.renderDenied(
                source: source,
                permissions: permissions
            )
        }
        let range =
            AdminAnalyticsInsightsPage.Range(
                rawValue: request.queryString("range") ?? ""
            ) ?? .last7Days
        let now = Date()
        let from = now.addingTimeInterval(-range.duration).timeIntervalSince1970
        let to = now.timeIntervalSince1970
        do {
            let overview = try await interactor.getOverview(
                source: source.rawValue,
                from: from,
                to: to
            )

            return try await presenter.render(
                page: .init(
                    source: source,
                    selectedRange: range,
                    overview: overview
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                source: source,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
