import Foundation
import HTML

protocol AdminGetWebMenuPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isAdded: Bool,
        isRemoved: Bool
    ) -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
