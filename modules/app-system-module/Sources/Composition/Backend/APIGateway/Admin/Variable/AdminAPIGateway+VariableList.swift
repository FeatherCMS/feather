import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemVariableList(
        _ input: Operations.SystemVariableList.Input
    ) async throws -> Operations.SystemVariableList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
