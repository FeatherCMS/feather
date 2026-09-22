import AnalyticsContracts
import FeatherAdmin
import Hummingbird
import FeatherContracts

struct AdminListAnalyticsLogDefaultController:
    AdminListAnalyticsLogController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListAnalyticsLogInteractor,
            presenter: any AdminListAnalyticsLogPresenter
        )

    func getAnalyticsLogs(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
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
                    responseCode: statusCode
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
            error: error
        )
    }
}
