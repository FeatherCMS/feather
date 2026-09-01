import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts
import UserApplication
import UserBackend

extension AdminAPIGateway {

    public func userIdentitySessionList(
        _ input: Operations.UserIdentitySessionList.Input
    ) async throws -> Operations.UserIdentitySessionList.Output {
        let subject = try await CurrentSubject.require()
        let sessions = useCases.makeListIdentitySessions()
        let result = try await sessions.execute(
            subject: subject,
            input: .init(identityId: input.path.userIdentityId)
        )

        return .ok(
            .init(
                body: .json(
                    .init(items: result.items.map(map))
                )
            )
        )
    }
}
