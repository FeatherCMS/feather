import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationGet(
        _ input: Operations.UserInvitationGet.Input
    ) async throws -> Operations.UserInvitationGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeGetInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userInvitationId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
