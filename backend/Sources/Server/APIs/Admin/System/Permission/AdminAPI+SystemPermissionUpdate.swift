import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemPermissionUpdate(
        _ input: Operations.SystemPermissionUpdate.Input
    ) async throws -> Operations.SystemPermissionUpdate.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeEditPermission()
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
