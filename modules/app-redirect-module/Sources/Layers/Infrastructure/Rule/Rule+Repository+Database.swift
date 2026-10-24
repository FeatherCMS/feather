import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import RedirectDomain
public import RedirectModule

extension Rule.Repository {
    public struct Database: Interface {
        public let context: any DatabaseContext
        private let accessLayer: DatabaseAccessLayer<Rule.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: Rule.Model.New) async throws
            -> Rule.Model
        {
            let row = Rule.Table.Insert(
                id: context.idGenerator.generate(),
                source: model.source,
                destination: model.destination,
                statusCode: model.statusCode.rawValue,
                notes: model.notes
            )
            try await accessLayer.insert(row)
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return try mapModel(detail)
        }

        public func update(_ model: Rule.Model) async throws
            -> Rule.Model
        {
            try await accessLayer.update(
                .init(
                    source: model.source,
                    destination: model.destination,
                    statusCode: model.statusCode.rawValue,
                    notes: model.notes
                ),
                where: \.id,
                equals: model.id
            )
            return model
        }

        public func find(id: String) async throws -> Rule.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map(mapModel)
        }

        public func find(source: String) async throws
            -> Rule.Model?
        {
            try await accessLayer.selectFirst(by: \.source, equals: source)
                .map(mapModel)
        }

        public func delete(ids: [String]) async throws -> [String] {
            _ = try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }

        private func mapModel(
            _ row: Rule.Table.Detail
        ) throws -> Rule.Model {
            guard
                let statusCode = Rule.StatusCode(
                    rawValue: row.statusCode
                )
            else {
                throw RepositoryError.invalidEnumValue(String(row.statusCode))
            }
            return .init(
                id: row.id,
                source: row.source,
                destination: row.destination,
                statusCode: statusCode,
                notes: row.notes,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
