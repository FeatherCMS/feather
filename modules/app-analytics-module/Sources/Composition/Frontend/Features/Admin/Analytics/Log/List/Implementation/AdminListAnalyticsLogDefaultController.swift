import AnalyticsContracts
import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

struct AdminListAnalyticsLogDefaultController:
    AdminListAnalyticsLogController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminListAnalyticsLogInteractor,
            any AdminListAnalyticsLogPresenter
        >

    func getAnalyticsLogs(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let source = request.queryString("source")?
            .whitespaceTrimmed
        let method = request.queryString("method")?
            .whitespaceTrimmed
        let responseCode = request.queryString("responseCode")?
            .whitespaceTrimmed
        let normalizedMethod = method?.isEmpty == true ? nil : method
        let normalizedResponseCode =
            responseCode?.isEmpty == true
            ? nil
            : responseCode
        let statusCode = normalizedResponseCode.flatMap(Int.init)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.isLenient = false
        let requestedFromValue = request.queryString("from")?
            .whitespaceTrimmed
            .emptyToNil
        let requestedToValue = request.queryString("to")?
            .whitespaceTrimmed
            .emptyToNil
        let fromDate = requestedFromValue.flatMap(dateFormatter.date(from:))
        let toDate = requestedToValue.flatMap(dateFormatter.date(from:))
        let isValidRange: Bool
        if let fromDate, let toDate {
            isValidRange = fromDate < toDate
        }
        else {
            isValidRange = true
        }
        let selectedFrom = isValidRange ? fromDate : nil
        let selectedTo = isValidRange ? toDate : nil
        let fromValue = fromDate == nil ? "" : requestedFromValue ?? ""
        let toValue = toDate == nil ? "" : requestedToValue ?? ""
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: AnalyticsPermissions.Logs.list
        )
        let emptyModel = AdminListAnalyticsLogModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20,
            source: source ?? "",
            method: normalizedMethod ?? "",
            responseCode: normalizedResponseCode ?? ""
        )
        let model: AdminListAnalyticsLogModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listAnalyticsLogs(
                    page: page,
                    search: search,
                    source: source,
                    method: normalizedMethod,
                    responseCode: statusCode,
                    from: selectedFrom?.timeIntervalSince1970,
                    to: selectedTo.map {
                        $0.addingTimeInterval(60).timeIntervalSince1970
                    }
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return try await presenter.renderListPage(
            model: model,
            permissions: permissions,
            search: search,
            source: source,
            method: normalizedMethod,
            responseCode: normalizedResponseCode,
            from: fromValue,
            to: toValue,
            error: error
        )
    }
}
