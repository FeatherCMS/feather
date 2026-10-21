public import RedirectAdminAPI
import FeatherModuleKit
import RedirectApplication
import RedirectModule

extension AdminAPIGateway {

    public func redirectRuleList(
        _ input: Operations.RedirectRuleList.Input
    ) async throws -> Operations.RedirectRuleList.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeListRules()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )
        return .ok(
            .init(
                body: .json(result.items.map(map))
            )
        )
    }

    private func map(
        _ item: RedirectModule.Rule.List.Output.Item
    ) -> Components.Schemas.RedirectRuleListItemSchema {
        .init(
            id: item.id,
            source: item.source,
            destination: item.destination,
            statusCode: item.statusCode.rawValue
        )
    }
}
