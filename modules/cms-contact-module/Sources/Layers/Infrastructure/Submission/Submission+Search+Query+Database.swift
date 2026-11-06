public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherApplication
public import FeatherInfrastructure
import Foundation

extension Submission.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Submission.Search.Input.Query
        ) async throws -> Submission.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let searchPattern: String? = query.search.flatMap { value in
                guard !value.isEmpty else { return nil }
                return "%"
                    + value
                    .replacingOccurrences(of: "!", with: "!!")
                    .replacingOccurrences(of: "%", with: "!%")
                    .replacingOccurrences(of: "_", with: "!_")
                    + "%"
            }
            let searchTable = AccessLayer(
                connection: context.connection
            )
            let rows = try await searchTable.items(
                searchPattern: searchPattern,
                formKey: query.formKey,
                sort: query.sort,
                pageSize: page.size,
                offset: offset
            )
            let items = try rows.map { row in
                guard
                    let status = Submission.Model.Status(
                        rawValue: row.status
                    )
                else {
                    throw RepositoryError.invalidEnumValue(row.status)
                }
                return Submission.Search.Output.Item(
                    id: row.submissionID,
                    formKey: row.formKey,
                    formName: row.formName,
                    status: status,
                    createdAt: row.createdAt,
                    email: Self.email(from: row.valuesJSON)
                )
            }
            let total = try await searchTable.count(
                searchPattern: searchPattern,
                formKey: query.formKey
            )
            return .init(items: items, total: total)
        }

        private static func email(from valuesJSON: String) -> String? {
            guard
                let data = valuesJSON.data(using: .utf8),
                let object = try? JSONSerialization.jsonObject(with: data),
                let values = object as? [String: Any],
                let email = values.first(where: {
                    $0.key.localizedCaseInsensitiveCompare("email")
                        == .orderedSame
                })?
                .value as? String
            else {
                return nil
            }
            return email
        }
    }
}
