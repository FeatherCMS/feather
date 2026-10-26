import FeatherApplication
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemVariableList(
        _ input: Operations.SystemVariableList.Input
    ) async throws -> Operations.SystemVariableList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListVariables()
            .execute(
                subject: subject,
                input: .init(
                    query: .init(
                        limit: input.query.limit,
                        search: input.query.search,
                        ids: input.query.ids
                    )
                )
            )

        return .ok(
            .init(
                body: .json(result.items.map(variableListItemSchema(from:)))
            )
        )
    }

    private func variableListItemSchema(
        from item: Variable.List.Output.Item
    ) -> Components.Schemas.SystemVariableListItemSchema {
        .init(
            id: item.id,
            key: item.key,
            value: item.value,
            name: item.name,
            notes: item.notes
        )
    }
}
