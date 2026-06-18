import AdminOpenAPI
import SystemApplication

extension AdminAPI {

    func systemVariableFilters(
        _ input: Operations.SystemVariableFilters.Input
    ) async throws -> Operations.SystemVariableFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
