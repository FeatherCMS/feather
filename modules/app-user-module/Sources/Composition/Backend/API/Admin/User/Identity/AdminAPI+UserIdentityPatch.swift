import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication
import UserDomain

extension UserBackend {

    public func userIdentityPatch(
        _ input: Operations.UserIdentityPatch.Input
    ) async throws -> Operations.UserIdentityPatch.Output {
        let body: Components.Schemas.UserIdentityPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeEditIdentity()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userIdentityId,
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
