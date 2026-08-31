import AccountAppAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AppAPIGateway {

    public func accountProfileGet(
        _ input: Operations.AccountProfileGet.Input
    ) async throws -> Operations.AccountProfileGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetAccountProfile().execute(
            subject: subject,
            input: .init()
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        firstName: result.firstName,
                        lastName: result.lastName,
                        imageURL: result.imageURL
                    )
                )
            )
        )
    }

    public func accountProfileUpdate(
        _ input: Operations.AccountProfileUpdate.Input
    ) async throws -> Operations.AccountProfileUpdate.Output {
        let body: Components.Schemas.AccountProfileUpdateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditAccountProfile().execute(
            subject: subject,
            input: .init(
                firstName: body.firstName,
                lastName: body.lastName,
                imageURL: body.imageURL
            )
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        firstName: result.firstName,
                        lastName: result.lastName,
                        imageURL: result.imageURL
                    )
                )
            )
        )
    }
}
