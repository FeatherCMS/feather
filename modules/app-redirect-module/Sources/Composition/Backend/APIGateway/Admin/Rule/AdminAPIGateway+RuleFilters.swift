import RedirectAdminAPI
import RedirectApplication

extension AdminAPIGateway {

    public func redirectRuleFilters(
        _ input: Operations.RedirectRuleFilters.Input
    ) async throws -> Operations.RedirectRuleFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
