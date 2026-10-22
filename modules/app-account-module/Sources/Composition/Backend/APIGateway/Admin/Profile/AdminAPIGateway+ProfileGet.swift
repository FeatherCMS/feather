public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountProfileGet(
        _ input: Operations.AccountProfileGet.Input
    ) async throws -> Operations.AccountProfileGet.Output {
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
                        profileImageAssetId: result.profileImageAssetId
                    )
                )
            )
        )
    }
}
