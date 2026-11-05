import FeatherModuleKit
public import RedirectAdminAPI
import RedirectApplication

extension AdminAPIGateway {

    public func redirectRuleRemove(
        _ input: Operations.RedirectRuleRemove.Input
    ) async throws -> Operations.RedirectRuleRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRemoveRule()
        let subject = try await CurrentSubject.require()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
