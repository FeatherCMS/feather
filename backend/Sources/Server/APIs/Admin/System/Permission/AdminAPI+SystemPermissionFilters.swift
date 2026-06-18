import AdminOpenAPI
import SystemApplication

extension AdminAPI {

    func systemPermissionFilters(
        _ input: Operations.SystemPermissionFilters.Input
    ) async throws -> Operations.SystemPermissionFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
