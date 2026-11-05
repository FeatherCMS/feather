public import ContactAdminAPI
import ContactApplication
import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFieldQuery(
        _ input: Operations.ContactFieldQuery.Input
    ) async throws -> Operations.ContactFieldQuery.Output {
        let requestQuery:
            Components.Schemas.ContactFieldQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            requestQuery = value
        }

        let defaults = Search.Page()
        let page =
            Search.Page(
                size: requestQuery.page?.size ?? defaults.size,
                number: requestQuery.page?.number ?? defaults.number
            )
            .normalized()
        let sort = (requestQuery.sort ?? [])
            .map { rule in
                FormField.Search.Input.Query.Sort(
                    field: searchSortField(from: rule.field),
                    direction: rule.direction == .asc ? .asc : .desc
                )
            }
        let requestedForm = requestQuery.filters.form
        let isUnassigned = requestedForm == "__unassigned__"
        let formKey = isUnassigned ? nil : requestedForm
        let result = try await useCases.makeSearchFormFields()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: requestQuery.filters.search,
                        formKey: formKey,
                        isUnassigned: isUnassigned
                    )
                )
            )

        let responseSort = requestQuery.sort?
            .map { rule in
                Components.Schemas
                    .ContactFieldQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: responseSortField(from: rule.field),
                        direction: rule.direction
                    )
            }
        let responseForm: String? = isUnassigned ? "__unassigned__" : formKey

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(size: page.size, number: page.number),
                            sort: responseSort,
                            filters: .init(
                                search: requestQuery.filters.search,
                                form: responseForm
                            )
                        ),
                        data: .init(
                            items: result.items.map(searchItemSchema(from:)),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func searchSortField(
        from field: Components.Schemas
            .ContactFieldQueryItemSearchRequestQuerySchema.SortPayloadPayload
            .FieldPayload
    ) -> FormField.Search.Input.Query.Sort.Field {
        switch field {
        case .key: .key
        case .label: .label
        case ._type: .type
        case .isRequired: .isRequired
        }
    }

    private func responseSortField(
        from field: Components.Schemas
            .ContactFieldQueryItemSearchRequestQuerySchema.SortPayloadPayload
            .FieldPayload
    )
        -> Components.Schemas
        .ContactFieldQueryItemSearchResponseQuerySchema
        .SortPayloadPayload.FieldPayload
    {
        switch field {
        case .key: .key
        case .label: .label
        case ._type: ._type
        case .isRequired: .isRequired
        }
    }

    private func searchItemSchema(
        from item: FormField.Search.Output.Item
    ) -> Components.Schemas.ContactFieldQueryItemSchema {
        .init(
            id: item.id,
            key: item.key,
            _type: item.type.rawValue,
            label: item.label,
            isRequired: item.isRequired
        )
    }
}
