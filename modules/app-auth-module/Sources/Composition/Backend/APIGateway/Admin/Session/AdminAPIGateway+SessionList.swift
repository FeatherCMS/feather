public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func userIdentitySessionList(
        _ input: Operations.UserIdentitySessionList.Input
    ) async throws -> Operations.UserIdentitySessionList.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeListSessions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(identityId: input.path.userIdentityId)
        )

        return .ok(
            .init(
                body: .json(
                    .init(items: result.items.map(mapSession))
                )
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapSession(
        _ item: Session.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.UserAuthSessionListItemSchema {
        .init(
            id: item.id,
            authenticationType: item.authenticationType,
            authenticationReference: item.authenticationReference,
            expiresAt: item.expiresAt,
            isPersistent: item.isPersistent,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
