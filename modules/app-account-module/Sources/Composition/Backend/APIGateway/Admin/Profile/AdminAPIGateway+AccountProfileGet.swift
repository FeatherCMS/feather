import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func adminAccountProfileGet(
        _ input: Operations.AdminAccountProfileGet.Input
    ) async throws -> Operations.AdminAccountProfileGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetAccountProfile()
            .execute(
                subject: subject,
                input: .init(userId: input.path.userId)
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
