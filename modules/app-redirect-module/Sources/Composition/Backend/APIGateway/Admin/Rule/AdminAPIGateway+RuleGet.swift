import FeatherModuleKit
public import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectModule

extension AdminAPIGateway {

    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeDetailRule()
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

    private func map(
        _ detail: Rule.Detail.Output
    ) -> Components.Schemas.RedirectRuleDetailSchema {
        .init(
            id: detail.id,
            source: detail.source,
            destination: detail.destination,
            statusCode: detail.statusCode.rawValue,
            notes: detail.notes
        )
    }
}
