import AdminOpenAPI
import RedirectApplication

extension AdminAPI {

    func redirectRuleFilters(
        _ input: Operations.RedirectRuleFilters.Input
    ) async throws -> Operations.RedirectRuleFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
