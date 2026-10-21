import FeatherApplication
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {
    public func userIdentityList(
        _ input: Operations.UserIdentityList.Input
    ) async throws -> Operations.UserIdentityList.Output {
        let subject = try await CurrentSubject.require()
        let limit = min(max(input.query.limit ?? 20, 1), 100)
        let result = try await useCases.makeSearchIdentities()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: .init(size: limit),
                        search: input.query.search,
                        role: input.query.role
                    )
                )
            )

        return .ok(
            .init(
                body: .json(result.items.map(identityListItemSchema(from:)))
            )
        )
    }

    private func identityListItemSchema(
        from item: Identity.Search.Output.Item
    ) -> Components.Schemas.UserIdentityListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            status: .init(rawValue: item.status.rawValue)!,
            roles: item.roles
        )
    }
}
