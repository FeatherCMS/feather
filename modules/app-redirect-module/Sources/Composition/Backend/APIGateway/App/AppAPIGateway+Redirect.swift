public import RedirectAppAPI
import RedirectApplication
import RedirectContracts

extension AppAPIGateway {
    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let rule = try await useCases.makeGetPublicRuleBySource()
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
}
