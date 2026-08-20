import FeatherInfrastructure
import RedirectAppAPI
import RedirectApplication
import RedirectDomain

extension AppAPIGateway {
    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        do {
            let rule = try await self.useCases.makeGetPublicRuleBySource()
                .execute(source: input.query.source)
            return .ok(
                .init(
                    body: .json(
                        .init(
                            source: rule.source,
                            destination: rule.destination,
                            statusCode: rule.statusCode.rawValue
                        )
                    )
                )
            )
        }
        catch is GetPublicRuleBySource.Error {
            return .notFound
        }
    }
}
