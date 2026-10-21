import RedirectModule
extension RedirectModule.Rule.Add {
    enum Repository {}
}

extension RedirectModule.Rule.Add.Repository {
    protocol Interface: Sendable {
    func create(
        input: RedirectRuleAddFormInput
    ) async throws
    }
}
