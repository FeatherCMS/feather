import RedirectModule
import FeatherWebAdmin
import RedirectApplication

extension RedirectModule.Rule.View {
    enum Presenter {}
}

extension RedirectModule.Rule.View.Presenter {
    protocol Interface: Sendable {

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(error: RedirectModule.Rule.View.Error) async throws
        -> HTMLResponse
    }
}
