import AdminOpenAPI
import UserApplication

extension AdminAPI {

    func userRoleFilters(
        _ input: Operations.UserRoleFilters.Input
    ) async throws -> Operations.UserRoleFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
