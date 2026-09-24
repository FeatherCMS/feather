import AnalyticsContracts
import FeatherAdmin
import Foundation
import Hummingbird

struct AdminViewAnalyticsNotFoundDefaultController:
    AdminViewAnalyticsNotFoundController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAnalyticsNotFoundInteractor,
            any AdminViewAnalyticsNotFoundPresenter
        >

    func getNotFound(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: AnalyticsPermissions.NotFound.list
        )
        if !canAccess {
            return try await presenter.renderDenied(permissions: permissions)
        }
        let now = Date()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.isLenient = false
        let requestedFromValue = request.queryString("from")
        let requestedToValue = request.queryString("to")
        let requestedFrom = requestedFromValue.flatMap(formatter.date(from:))
        let requestedTo = requestedToValue.flatMap(formatter.date(from:))
        let defaultFrom = now.addingTimeInterval(-(86_400 * 7))
        let fromDate = requestedFrom ?? defaultFrom
        let toDate = requestedTo ?? now
        let isValidRange = fromDate < toDate
        let from = (isValidRange ? fromDate : defaultFrom)
            .timeIntervalSince1970
        let to = (isValidRange ? toDate : now).timeIntervalSince1970
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
            let overview = try await interactor.getOverview(from: from, to: to)
            return try await presenter.render(
                model: .init(
                    title: "404s",
                    description: "404 trends and missing routes.",
                    from: fromValue,
                    to: toValue,
                    overview: overview
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }
}
