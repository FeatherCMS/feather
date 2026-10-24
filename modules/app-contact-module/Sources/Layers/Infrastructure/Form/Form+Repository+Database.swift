public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Form.Table.Detail {
    var asDomain: Form.Model {
        .init(
            id: id,
            key: key,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Form.Table.List {
    var asDomain: Form.Model {
        .init(
            id: id,
            key: key,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Form.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func list() async throws -> [Form.Model] {
            try await DatabaseAccessLayer<Form.Table>(context: context)
                .select { $0.order(by: \.name).order(by: \.id) }
                .map(\.asDomain)
        }

        public func insert(
            _ model: Form.Model.New
        ) async throws -> Form.Model {
            let accessLayer = DatabaseAccessLayer<Form.Table>(context: context)
            let row = Form.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                successMessage: model.successMessage,
                failureMessage: model.failureMessage,
                redirectUrl: model.redirectUrl
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain
        }

        public func findBy(
            id: String
        ) async throws -> Form.Model? {
            try await DatabaseAccessLayer<Form.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map(\.asDomain)
        }

        public func findBy(
            key: String
        ) async throws -> Form.Model? {
            try await DatabaseAccessLayer<Form.Table>(context: context)
                .selectFirst(by: \.key, equals: key)
                .map(\.asDomain)
        }

        public func update(
            _ model: Form.Model
        ) async throws -> Form.Model {
            let accessLayer = DatabaseAccessLayer<Form.Table>(context: context)
            try await accessLayer.update(
                .init(
                    key: model.key,
                    name: model.name,
                    successMessage: model.successMessage,
                    failureMessage: model.failureMessage,
                    redirectUrl: model.redirectUrl
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Form.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
