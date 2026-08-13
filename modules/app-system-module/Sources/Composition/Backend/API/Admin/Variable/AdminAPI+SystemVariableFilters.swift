import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemVariableFilters(
        _ input: Operations.SystemVariableFilters.Input
    ) async throws -> Operations.SystemVariableFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
