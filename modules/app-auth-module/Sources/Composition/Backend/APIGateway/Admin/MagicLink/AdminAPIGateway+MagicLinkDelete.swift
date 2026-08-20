import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authMagicLinkDelete(
        _ input: Operations.AuthMagicLinkDelete.Input
    ) async throws -> Operations.AuthMagicLinkDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemoveMagicLink()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.authMagicLinkId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
