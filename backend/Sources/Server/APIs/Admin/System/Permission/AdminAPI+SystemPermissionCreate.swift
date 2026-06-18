import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemPermissionCreate(
        _ input: Operations.SystemPermissionCreate.Input
    ) async throws -> Operations.SystemPermissionCreate.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.system.makeAddPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                notes: body.notes ?? ""
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
