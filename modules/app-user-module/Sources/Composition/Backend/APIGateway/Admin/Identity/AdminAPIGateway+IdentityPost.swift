import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userIdentityPost(
        _ input: Operations.UserIdentityPost.Input
    ) async throws -> Operations.UserIdentityPost.Output {
        let body: Components.Schemas.UserIdentityCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeAddIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                status: Identity.Model.Status(
                    rawValue: body.status?.rawValue ?? "invited"
                )
                    ?? .invited,
                roleIds: Array(body.roleIds ?? [])
            )
        )

        return .created(
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
