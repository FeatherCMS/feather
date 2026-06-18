import Foundation

protocol AdminGetAnalyticsLogPresenter: Sendable {

    func renderPage(
        model: AdminGetAnalyticsLogModel,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
