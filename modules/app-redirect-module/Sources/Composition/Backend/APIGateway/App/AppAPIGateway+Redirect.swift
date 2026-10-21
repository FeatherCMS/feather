public import RedirectAppAPI
import RedirectApplication
import RedirectModule

extension AppAPIGateway {
    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let rule: RedirectModule.Rule.Resolve.Output
        do {
            rule = try await useCases.makeResolveRule()
                .execute(input: .init(source: input.query.source))
        } catch RedirectModule.Rule.Resolve.UseCase.Error.notFound {
            return .notFound(.init())
        }

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
