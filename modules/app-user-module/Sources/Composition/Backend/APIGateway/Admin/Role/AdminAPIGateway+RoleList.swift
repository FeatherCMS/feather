import FeatherApplication
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserModule

extension AdminAPIGateway {
    public func userRoleList(
        _ input: Operations.UserRoleList.Input
    ) async throws -> Operations.UserRoleList.Output {
        let subject = try await CurrentSubject.require()
        let limit = min(max(input.query.limit ?? 20, 1), 100)
        let result = try await useCases.makeListRoles()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: .init(size: limit),
                        search: input.query.search
                    )
                )
            )

        return .ok(
            .init(
                body: .json(result.items.map(roleListItemSchema(from:)))
            )
        )
    }

    private func roleListItemSchema(
        from item: Role.List.Output.Item
    ) -> Components.Schemas.UserRoleListItemSchema {
        .init(id: item.id, key: item.key, name: item.name)
    }
}
