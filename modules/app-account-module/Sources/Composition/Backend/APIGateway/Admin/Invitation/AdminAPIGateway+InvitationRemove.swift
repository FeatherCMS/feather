public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountInvitationRemove(
        _ input: Operations.AccountInvitationRemove.Input
    ) async throws -> Operations.AccountInvitationRemove.Output {
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
