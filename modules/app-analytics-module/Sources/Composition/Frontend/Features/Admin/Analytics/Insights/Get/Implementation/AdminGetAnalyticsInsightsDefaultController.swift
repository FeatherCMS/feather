import AnalyticsContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

struct AdminGetAnalyticsInsightsDefaultController:
    AdminGetAnalyticsInsightsController
{
    let source: AdminAnalyticsInsightsPage.Source
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAnalyticsInsightsInteractor,
            presenter: any AdminGetAnalyticsInsightsPresenter
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
            return presenter.renderDenied(
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

            return presenter.render(
                page: .init(
                    source: source,
                    selectedRange: range,
                    overview: overview
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                source: source,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
