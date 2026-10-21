import RedirectModule
import RedirectApplication
extension RedirectModule.Rule.View {
    enum Repository {}
}

extension RedirectModule.Rule.View.Repository {
    protocol Interface: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
    }
}
