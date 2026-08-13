import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemPermissionFilters(
        _ input: Operations.SystemPermissionFilters.Input
    ) async throws -> Operations.SystemPermissionFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
