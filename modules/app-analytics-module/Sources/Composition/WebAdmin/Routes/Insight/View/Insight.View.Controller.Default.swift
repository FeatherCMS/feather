import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension Insight.View.Controller {
    struct Default: Interface {
        let source: Insight.View.Model.Source
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Insight.View.Interactor.Interface,
                any Insight.View.Presenter.Interface
            >

        func getInsights(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Insight.Permissions.list
            )
            if !canAccess {
                return try await presenter.renderDenied(
                    source: source,
                    permissions: permissions
                )
            }
            let dateFormatter = context.adminDateFormatter

            let now = Date()
            let defaultFrom = now.addingTimeInterval(-(86_400 * 7))
            let requestedFromValue = request.queryString("from")
            let requestedToValue = request.queryString("to")
            let requestedFrom = requestedFromValue.flatMap(
                dateFormatter.parseDateTimeInput
            )
            let requestedTo = requestedToValue.flatMap(
                dateFormatter.parseDateTimeInput
            )
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
                fromValue = dateFormatter.formatDateTimeInput(
                    unixTimestamp: from
                )
            }
            let toValue: String
            if requestedTo != nil, let requestedToValue {
                toValue = requestedToValue
            }
            else {
                toValue = dateFormatter.formatDateTimeInput(
                    unixTimestamp: to
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
}
