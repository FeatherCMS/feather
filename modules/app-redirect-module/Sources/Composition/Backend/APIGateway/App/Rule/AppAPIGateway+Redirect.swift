public import RedirectAppAPI
import RedirectApplication
import RedirectModule

extension AppAPIGateway {
    public func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        let rule: Rule.Resolve.Output
        do {
            rule = try await useCases.makeResolveRule()
                .execute(input: .init(source: input.query.source))
        }
        catch Rule.Resolve.Error.notFound {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Redirect rule not found",
                                reason: "No redirect rule matches this source."
                            )
                        )
                    )
                )
            )
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
