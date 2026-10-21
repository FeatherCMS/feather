import FeatherDomain
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userRolePut(
        _ input: Operations.UserRolePut.Input
    ) async throws -> Operations.UserRolePut.Output {
        let body: Components.Schemas.UserRoleUpdateSchema
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
                name: body.name.map(OptionalFieldChange.set) ?? .unchanged,
                notes: body.notes.map(OptionalFieldChange.set) ?? .unchanged
            )
        )

        return .ok(
            .init(
                body: .json(roleDetailSchema(from: result))
            )
        )
    }
}

private func roleDetailSchema(
    from output: Role.Edit.Output
) -> Components.Schemas.UserRoleDetailSchema {
    .init(
        id: output.id,
        key: output.key,
        name: output.name,
        notes: output.notes
    )
}
