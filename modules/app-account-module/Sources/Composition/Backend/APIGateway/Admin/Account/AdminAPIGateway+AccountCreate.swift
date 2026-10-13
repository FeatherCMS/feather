public import AccountAdminAPI
import AccountApplication
import FeatherContracts

extension AdminAPIGateway {

    public func accountCreate(
        _ input: Operations.AccountCreate.Input
    ) async throws -> Operations.AccountCreate.Output {
        let body: Components.Schemas.AccountCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeCreateAccount()
            .execute(
                subject: subject,
                input: .init(
                    email: body.email,
                    password: body.password
                )
            )

        return .created(
            .init(
                body: .json(
                    .init(userId: result.userId, email: result.email)
                )
            )
        )
    }
}
