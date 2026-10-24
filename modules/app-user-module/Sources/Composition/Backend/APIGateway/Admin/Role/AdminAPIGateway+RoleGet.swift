import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userRoleGet(
        _ input: Operations.UserRoleGet.Input
    ) async throws -> Operations.UserRoleGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userRoleId)
        )

        return .ok(
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
