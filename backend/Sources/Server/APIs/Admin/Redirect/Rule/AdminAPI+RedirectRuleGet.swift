import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.redirect.makeGetRule()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.redirectRuleId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
