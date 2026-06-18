import AdminOpenAPI
import UserApplication

extension AdminAPI {

    func userAccountFilters(
        _ input: Operations.UserAccountFilters.Input
    ) async throws -> Operations.UserAccountFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
