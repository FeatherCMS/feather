import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension UserBackend {

    public func userRoleCreate(
        _ input: Operations.UserRoleCreate.Input
    ) async throws -> Operations.UserRoleCreate.Output {
        let body: Components.Schemas.UserRoleCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeAddRole()
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
