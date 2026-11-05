public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountInvitationDelete(
        _ input: Operations.AccountInvitationDelete.Input
    ) async throws -> Operations.AccountInvitationDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveInvitation()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
