import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationPatch(
        _ input: Operations.UserInvitationPatch.Input
    ) async throws -> Operations.UserInvitationPatch.Output {
        let body: Components.Schemas.UserInvitationPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeEditInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: UserApplication.EditInvitation.Input(
                id: input.path.userInvitationId,
                email: body.email
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
