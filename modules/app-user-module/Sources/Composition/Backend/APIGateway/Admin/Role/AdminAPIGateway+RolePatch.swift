import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRolePatch(
        _ input: Operations.UserRolePatch.Input
    ) async throws -> Operations.UserRolePatch.Output {
        let body: Components.Schemas.UserRolePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditRole()
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
