import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemVariablePresenter: Sendable {

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
