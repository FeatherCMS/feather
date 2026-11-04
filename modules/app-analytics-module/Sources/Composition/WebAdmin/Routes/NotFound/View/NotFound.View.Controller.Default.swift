import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension NotFound.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any NotFound.View.Interactor.Interface,
                any NotFound.View.Presenter.Interface
            >

        func getNotFound(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: NotFound.Permissions.list
            )
            if !canAccess {
                return try await presenter.renderDenied(
                    permissions: permissions
                )
            }
            let now = Date()
            let dateFormatter = context.adminDateFormatter
            let requestedFromValue = request.queryString("from")
            let requestedToValue = request.queryString("to")
            let requestedFrom = requestedFromValue.flatMap(
                dateFormatter.parseDateTimeInput
            )
            let requestedTo = requestedToValue.flatMap(
                dateFormatter.parseDateTimeInput
            )
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
                    from: from,
                    to: to
                )
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
}
