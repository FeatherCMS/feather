import Application
import AuthApplication
import AdminOpenAPI
import UserApplication

extension AdminAPI {

    func userAccountSessionList(
        _ input: Operations.UserAccountSessionList.Input
    ) async throws -> Operations.UserAccountSessionList.Output {
        let subject = try await CurrentSubject.require()
        let getAccount = modules.user.makeGetAccount()
        let sessions = modules.auth.makeListAccountSessions()
        _ = try await getAccount.execute(
            subject: subject,
            input: .init(id: input.path.userAccountId)
        )

        let result = try await sessions.execute(
            subject: subject,
            input: .init(accountId: input.path.userAccountId)
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
