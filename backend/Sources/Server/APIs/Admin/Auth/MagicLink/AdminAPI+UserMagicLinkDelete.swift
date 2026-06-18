import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userMagicLinkDelete(
        _ input: Operations.UserMagicLinkDelete.Input
    ) async throws -> Operations.UserMagicLinkDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeRemoveMagicLink()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userMagicLinkId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
