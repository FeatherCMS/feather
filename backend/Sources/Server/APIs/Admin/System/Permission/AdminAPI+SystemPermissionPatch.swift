import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemPermissionPatch(
        _ input: Operations.SystemPermissionPatch.Input
    ) async throws -> Operations.SystemPermissionPatch.Output {
        let body: Components.Schemas.SystemPermissionPatchSchema
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
