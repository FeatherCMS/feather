public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationList(
        _ input: Operations.AccountInvitationList.Input
    ) async throws -> Operations.AccountInvitationList.Output {
        let subject = try await CurrentSubject.require()
        let list = try await useCases.makeListInvitations()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(
            .init(
                body: .json(
                    list.items.map { item in
                        .init(
                            id: item.id,
                            email: item.email,
                            token: item.token,
                            roleIds: item.roleIDs,
                            expiresAt: item.expiresAt.timeIntervalSince1970
                        )
                    }
                )
            )
        )
    }
}
