import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
public import NewsletterModule

extension Campaign.Detail.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func find(id: String) async throws -> Campaign.Detail.Output {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw QueryError.notFound
            }

            return .init(
                id: row.id,
                key: row.key,
                name: row.name,
                fromEmail: row.fromEmail,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }

        public func find(key: String) async throws -> Campaign.Detail.Output {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.key,
                    equals: key
                )
            else {
                throw QueryError.notFound
            }

            return .init(
                id: row.id,
                key: row.key,
                name: row.name,
                fromEmail: row.fromEmail,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
