import Infrastructure
import AppOpenAPI
import RedirectApplication

extension AppAPI {
    func redirectRuleGet(
        _ input: Operations.RedirectRuleGet.Input
    ) async throws -> Operations.RedirectRuleGet.Output {
        do {
            let rule = try await modules.redirect.makeGetPublicRuleBySource()
                .execute(source: input.query.source)
            return .ok(
                .init(
                    body: .json(
                        .init(
                            source: rule.source,
                            destination: rule.destination,
                            statusCode: rule.statusCode
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
