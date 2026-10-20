import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userRolePost(
        _ input: Operations.UserRolePost.Input
    ) async throws -> Operations.UserRolePost.Output {
        let body: Components.Schemas.UserRoleCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeAddRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                key: body.key,
                name: body.name,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(roleDetailSchema(from: result))
            )
        )
    }
}

private func roleDetailSchema(
    from output: Role.Detail.Output
) -> Components.Schemas.UserRoleDetailSchema {
    .init(
        id: output.id,
        key: output.key,
        name: output.name,
        notes: output.notes
    )
}
