import FeatherApplication
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemPermissionList(
        _ input: Operations.SystemPermissionList.Input
    ) async throws -> Operations.SystemPermissionList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListPermissions()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        page: .init(size: input.query.limit ?? 20),
                        search: input.query.search,
                        ids: input.query.ids
                    )
                )
            )

        return .ok(
            .init(
                body: .json(result.items.map(permissionListItemSchema(from:)))
            )
        )
    }

    private func permissionListItemSchema(
        from item: SystemModule.Permission.List.Output.Item
    ) -> Components.Schemas.SystemPermissionListItemSchema {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            notes: item.notes
        )
    }
}
