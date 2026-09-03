import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authMagicLinkCreate(
        _ input: Operations.AuthMagicLinkCreate.Input
    ) async throws -> Operations.AuthMagicLinkCreate.Output {
        let body: Components.Schemas.AuthMagicLinkCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                authEmailId: body.credentialId,
                isPersistent: body.isPersistent
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
