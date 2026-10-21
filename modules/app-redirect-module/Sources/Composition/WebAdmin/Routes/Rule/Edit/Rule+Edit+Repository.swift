import RedirectModule
extension RedirectModule.Rule.Edit {
    enum Repository {}
}

extension RedirectModule.Rule.Edit.Repository {
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
