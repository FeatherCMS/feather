import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication

extension RedirectBackend {

    public func redirectRuleDelete(
        _ input: Operations.RedirectRuleDelete.Input
    ) async throws -> Operations.RedirectRuleDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveRule()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.redirectRuleId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
