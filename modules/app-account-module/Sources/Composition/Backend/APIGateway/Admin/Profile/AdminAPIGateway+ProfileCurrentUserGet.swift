public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountCurrentUserProfileGet(
        _ input: Operations.AccountCurrentUserProfileGet.Input
    ) async throws -> Operations.AccountCurrentUserProfileGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetAccountProfile()
            .execute(
                subject: subject,
                input: .init()
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
