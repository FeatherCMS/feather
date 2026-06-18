import Application
import AuthApplication
import AdminOpenAPI
import UserApplication

extension AdminAPI {

    func userAccountSessionDelete(
        _ input: Operations.UserAccountSessionDelete.Input
    ) async throws -> Operations.UserAccountSessionDelete.Output {
        let subject = try await CurrentSubject.require()
        let getAccount = modules.user.makeGetAccount()
        let getSession = modules.auth.makeGetSession()
        let removeSession = modules.auth.makeRemoveSession()

        _ = try await getAccount.execute(
            subject: subject,
            input: .init(id: input.path.userAccountId)
        )

        let session = try await getSession.execute(
            subject: subject,
            input: .init(id: input.path.sessionId)
        )

        guard session.accountId == input.path.userAccountId else {
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
