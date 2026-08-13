import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemPermissionUpdate(
        _ input: Operations.SystemPermissionUpdate.Input
    ) async throws -> Operations.SystemPermissionUpdate.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.makeEditPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemPermissionId,
                name: body.name,
                notes: body.notes
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
