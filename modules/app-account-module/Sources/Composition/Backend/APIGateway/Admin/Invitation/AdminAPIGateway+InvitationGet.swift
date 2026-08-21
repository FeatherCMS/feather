import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func accountInvitationGet(
        _ input: Operations.AccountInvitationGet.Input
    ) async throws -> Operations.AccountInvitationGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.accountInvitationId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
