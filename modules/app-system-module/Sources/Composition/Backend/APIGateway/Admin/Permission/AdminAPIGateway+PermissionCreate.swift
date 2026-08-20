import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemPermissionCreate(
        _ input: Operations.SystemPermissionCreate.Input
    ) async throws -> Operations.SystemPermissionCreate.Output {
        let body: Components.Schemas.SystemPermissionCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddPermission()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: body.id,
                name: body.name,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
