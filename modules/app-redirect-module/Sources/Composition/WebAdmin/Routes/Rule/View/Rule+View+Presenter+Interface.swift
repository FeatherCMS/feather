import FeatherWebAdmin
import RedirectApplication
import RedirectModule

extension Rule.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            rule: RedirectRuleDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(error: Rule.View.Error) async throws
            -> HTMLResponse
    }
}
