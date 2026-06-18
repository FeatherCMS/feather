import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userMagicLinkGet(
        _ input: Operations.UserMagicLinkGet.Input
    ) async throws -> Operations.UserMagicLinkGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeGetMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: GetMagicLink.Input(id: input.path.userMagicLinkId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
