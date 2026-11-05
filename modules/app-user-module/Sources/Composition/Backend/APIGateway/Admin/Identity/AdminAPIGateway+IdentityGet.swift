import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userIdentityGet(
        _ input: Operations.UserIdentityGet.Input
    ) async throws -> Operations.UserIdentityGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDetailIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userIdentityId)
        )

        return .ok(
            .init(
                body: .json(identityDetailSchema(from: result))
            )
        )
    }
}

private func identityDetailSchema(
    from output: Identity.Detail.Output
) -> Components.Schemas.UserIdentityDetailSchema {
    .init(
        id: output.id,
        name: output.name,
        status: .init(rawValue: output.status.rawValue)!,
        roleIds: output.roleIds
    )
}
