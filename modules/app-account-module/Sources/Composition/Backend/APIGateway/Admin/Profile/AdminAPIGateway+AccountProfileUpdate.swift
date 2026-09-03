import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func adminAccountProfileUpdate(
        _ input: Operations.AdminAccountProfileUpdate.Input
    ) async throws -> Operations.AdminAccountProfileUpdate.Output {
        let body: Components.Schemas.AccountProfileUpdateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditAccountProfile()
            .execute(
                subject: subject,
                input: .init(
                    firstName: body.firstName,
                    lastName: body.lastName,
                    profileImageAssetId: body.profileImageAssetId,
                    userId: input.path.userId
                )
            )
        return .ok(
            .init(
                body: .json(
                    .init(
                        firstName: result.firstName,
                        lastName: result.lastName,
                        profileImageAssetId: result.profileImageAssetId
                    )
                )
            )
        )
    }
}
