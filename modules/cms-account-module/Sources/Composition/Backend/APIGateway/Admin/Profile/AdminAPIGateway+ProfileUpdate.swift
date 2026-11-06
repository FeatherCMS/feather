public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountProfileUpdate(
        _ input: Operations.AccountProfileUpdate.Input
    ) async throws -> Operations.AccountProfileUpdate.Output {
        let body: Components.Schemas.AccountProfileUpdateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditProfile()
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
