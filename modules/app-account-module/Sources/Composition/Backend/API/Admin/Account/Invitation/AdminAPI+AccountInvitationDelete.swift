import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountInvitationDelete(
        _ input: Operations.AccountInvitationDelete.Input
    ) async throws -> Operations.AccountInvitationDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeRemoveInvitation()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.accountInvitationId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
