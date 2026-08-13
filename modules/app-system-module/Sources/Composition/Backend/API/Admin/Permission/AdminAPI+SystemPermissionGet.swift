import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemPermissionGet(
        _ input: Operations.SystemPermissionGet.Input
    ) async throws -> Operations.SystemPermissionGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeGetPermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemPermissionId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
