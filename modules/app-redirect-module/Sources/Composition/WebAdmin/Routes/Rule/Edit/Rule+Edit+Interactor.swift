import RedirectApplication
import RedirectModule
extension RedirectModule.Rule.Edit {
    enum Interactor {}
}

extension RedirectModule.Rule.Edit.Interactor {
    protocol Interface: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleEditModel

    func update(
        id: String,
        input: RedirectRuleEditFormInput
    ) async throws
    }
}
