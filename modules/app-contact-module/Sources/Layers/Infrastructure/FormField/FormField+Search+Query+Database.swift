public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherApplication
public import FeatherInfrastructure
import Foundation

extension FormField.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: FormField.Search.Input.Query
        ) async throws -> FormField.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let searchPattern = query.search.flatMap { value -> String? in
                guard !value.isEmpty else { return nil }
                return "%"
                    + value
                    .replacingOccurrences(of: "!", with: "!!")
                    .replacingOccurrences(of: "%", with: "!%")
                    .replacingOccurrences(of: "_", with: "!_")
                    + "%"
            }
            let searchTable = FormFieldSearchQueryTable(
                connection: context.connection
            )
            let rows = try await searchTable.items(
                searchPattern: searchPattern,
                formKey: query.formKey,
                isUnassigned: query.isUnassigned,
                sort: query.sort,
                pageSize: page.size,
                offset: offset
            )
            let items = try rows.map { row in
                guard let type = FormField.Model.ItemType(rawValue: row.type)
                else {
                    throw RepositoryError.invalidEnumValue(row.type)
                }
                return FormField.Search.Output.Item(
                    id: row.id,
                    key: row.key,
                    type: type,
                    label: row.label,
                    isRequired: row.isRequired
                )
            }
            let total = try await searchTable.count(
                searchPattern: searchPattern,
                formKey: query.formKey,
                isUnassigned: query.isUnassigned
            )
            return .init(items: items, total: total)
        }
    }
}
