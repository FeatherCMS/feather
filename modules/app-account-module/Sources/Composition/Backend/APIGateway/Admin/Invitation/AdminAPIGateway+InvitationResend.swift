import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func accountInvitationResend(
        _ input: Operations.AccountInvitationResend.Input
    ) async throws -> Operations.AccountInvitationResend.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeResendInvitation().execute(
            subject: subject,
            input: .init(id: input.path.accountInvitationId)
        )
        return .ok(.init(body: .json(map(result))))
    }
}
