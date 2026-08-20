import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication

extension AdminAPIGateway {

    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeGetRule()
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
