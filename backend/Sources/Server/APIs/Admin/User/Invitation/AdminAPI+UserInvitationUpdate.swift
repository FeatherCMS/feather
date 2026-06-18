import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationUpdate(
        _ input: Operations.UserInvitationUpdate.Input
    ) async throws -> Operations.UserInvitationUpdate.Output {
        let body: Components.Schemas.UserInvitationCreateSchema
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
