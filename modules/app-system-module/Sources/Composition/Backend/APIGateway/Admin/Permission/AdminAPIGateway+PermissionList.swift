import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemPermissionList(
        _ input: Operations.SystemPermissionList.Input
    ) async throws -> Operations.SystemPermissionList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
