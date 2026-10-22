public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func authMagicLinkQuery(
        _ input: Operations.AuthMagicLinkQuery.Input
    ) async throws -> Operations.AuthMagicLinkQuery.Output {
        let query:
            Components.Schemas.AuthMagicLinkQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeSearchMagicLinks()
        let listQuery = map(query)
        let objectQuery = MagicLink.Search.Input.Query(
            page: listQuery.page,
            sort: listQuery.sort.map {
                .init(
                    field: .init(rawValue: $0.field.rawValue) ?? .id,
                    direction: $0.direction
                )
            },
            search: listQuery.search,
            userId: listQuery.userId
        )

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(query),
                        data: .init(
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    fileprivate func mapQuery(
        _ item: MagicLink.Search.Output.Item
    ) -> Components.Schemas.AuthMagicLinkQueryItemSchema {
        .init(
            id: item.id,
            credentialId: item.authEmailId,
            token: item.token,
            expiresAt: item.expiresAt.timeIntervalSince1970,
            isPersistent: item.isPersistent,
            isUsed: item.isUsed
        )
    }
}
