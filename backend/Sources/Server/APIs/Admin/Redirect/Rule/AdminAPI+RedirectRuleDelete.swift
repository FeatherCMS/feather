import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    func redirectRuleDelete(
        _ input: Operations.RedirectRuleDelete.Input
    ) async throws -> Operations.RedirectRuleDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.redirect.makeRemoveRule()
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
