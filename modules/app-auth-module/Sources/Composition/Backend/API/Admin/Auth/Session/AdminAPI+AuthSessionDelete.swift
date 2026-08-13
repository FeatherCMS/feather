import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts
import UserApplication
import UserBackend

extension AuthBackend {

    public func userIdentitySessionDelete(
        _ input: Operations.UserIdentitySessionDelete.Input
    ) async throws -> Operations.UserIdentitySessionDelete.Output {
        let subject = try await CurrentSubject.require()
        let getIdentity = user.makeGetIdentity()
        let getSession = self.makeGetSession()
        let removeSession = self.makeRemoveSession()

        _ = try await getIdentity.execute(
            subject: subject,
            input: .init(id: input.path.userIdentityId)
        )

        let session = try await getSession.execute(
            subject: subject,
            input: .init(id: input.path.sessionId)
        )

        guard session.identityId == input.path.userIdentityId else {
            return .notFound(.init())
        }

        let deleted = try await removeSession.execute(
            subject: subject,
            input: .init(id: input.path.sessionId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
