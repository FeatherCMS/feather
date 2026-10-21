import RedirectModule
extension RedirectModule.Rule.Add {
    enum Interactor {}
}

extension RedirectModule.Rule.Add.Interactor {
    protocol Interface: Sendable {
    func add(
        input: RedirectRuleAddFormInput
    ) async throws
    }
}
