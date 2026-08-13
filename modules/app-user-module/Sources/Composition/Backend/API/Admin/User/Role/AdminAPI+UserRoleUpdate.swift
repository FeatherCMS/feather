import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension UserBackend {

    public func userRoleUpdate(
        _ input: Operations.UserRoleUpdate.Input
    ) async throws -> Operations.UserRoleUpdate.Output {
        let body: Components.Schemas.UserRolePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeEditRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userRoleId,
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
