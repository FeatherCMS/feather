import RedirectModule
import RedirectApplication
extension RedirectModule.Rule.View {
    enum Interactor {}
}

extension RedirectModule.Rule.View.Interactor {
    protocol Interface: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
    }
}
