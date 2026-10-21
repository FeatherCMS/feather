import FeatherDomain
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userIdentityPut(
        _ input: Operations.UserIdentityPut.Input
    ) async throws -> Operations.UserIdentityPut.Output {
        let body: Components.Schemas.UserIdentityUpdateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userIdentityId,
                name: body.name.map(FieldChange.set) ?? .unchanged,
                roleIds: .set(body.roleIds ?? []),
                status: body.status
                    .flatMap {
                        Identity.Model.Status(rawValue: $0.rawValue)
                    }
                    .map(FieldChange.set) ?? .unchanged
            )
        )

        return .ok(
            .init(
                body: .json(identityDetailSchema(from: result))
            )
        )
    }
}

private func identityDetailSchema(
    from output: Identity.Edit.Output
) -> Components.Schemas.UserIdentityDetailSchema {
    .init(
        id: output.id,
        name: output.name,
        status: .init(rawValue: output.status.rawValue)!,
        roleIds: output.roleIds
    )
}
