import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication
import UserDomain

extension AdminAPIGateway {

    public func userIdentityUpdate(
        _ input: Operations.UserIdentityUpdate.Input
    ) async throws -> Operations.UserIdentityUpdate.Output {
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
                name: body.name,
                roleIds: body.roleIds,
                status: body.status.flatMap {
                    Identity.Status(rawValue: $0.rawValue)
                }
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
