import Foundation
import HTML

protocol AdminGetWebPagePresenter: Sendable {

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool
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
