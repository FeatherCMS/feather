import FeatherAdmin
import Foundation
import HTML

protocol AdminGetSystemVariablePresenter: Sendable {

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        breadcrumb: NewAdminBreadcrumb.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: NewAdminBreadcrumb.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
