import RedirectAdminAPI
import RedirectApplication

extension AdminAPIGateway {

    public func redirectRuleList(
        _ input: Operations.RedirectRuleList.Input
    ) async throws -> Operations.RedirectRuleList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
