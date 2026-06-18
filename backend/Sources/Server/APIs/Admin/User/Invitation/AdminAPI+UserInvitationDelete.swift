import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationDelete(
        _ input: Operations.UserInvitationDelete.Input
    ) async throws -> Operations.UserInvitationDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeRemoveInvitation()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userInvitationId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
