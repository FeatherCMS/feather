import AnalyticsContracts
import FeatherAdmin
import Foundation
import Hummingbird

struct AdminViewAnalyticsInsightsDefaultController:
    AdminViewAnalyticsInsightsController
{
    let source: AdminAnalyticsInsightsPage.Source
    let buildRuntime:
        RuntimeBuilder<
            any AdminViewAnalyticsInsightsInteractor,
            any AdminViewAnalyticsInsightsPresenter
        >

    func getInsights(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
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
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.isLenient = false

        let now = Date()
        let defaultFrom = now.addingTimeInterval(-(86_400 * 7))
        let requestedFromValue = request.queryString("from")
        let requestedToValue = request.queryString("to")
        let requestedFrom = requestedFromValue.flatMap(formatter.date(from:))
        let requestedTo = requestedToValue.flatMap(formatter.date(from:))
        let fromDate = requestedFrom ?? defaultFrom
        let toDate = requestedTo ?? now
        let isValidRange = fromDate < toDate
        let from = (isValidRange ? fromDate : defaultFrom)
            .timeIntervalSince1970
        let to = (isValidRange ? toDate : now).timeIntervalSince1970
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let fromValue: String
        if requestedFrom != nil, let requestedFromValue {
            fromValue = requestedFromValue
        }
        else {
            fromValue = formatter.string(
                from: Date(timeIntervalSince1970: from)
            )
        }
        let toValue: String
        if requestedTo != nil, let requestedToValue {
            toValue = requestedToValue
        }
        else {
            toValue = formatter.string(
                from: Date(timeIntervalSince1970: to)
            )
        }
        do {
            let overview = try await interactor.getOverview(
                source: source.rawValue,
                from: from,
                to: to
            )

            return try await presenter.render(
                page: .init(
                    source: source,
                    from: fromValue,
                    to: toValue,
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
