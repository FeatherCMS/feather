public import AccountDomain
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Settings.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func get(userId: String) async throws -> Settings.Model {
            guard
                let detail = try await DatabaseAccessLayer<Settings.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.userId,
                    equals: userId,
                    as: Settings.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func getOrCreate(userId: String) async throws -> Settings.Model {
            do {
                return try await get(userId: userId)
            }
            catch let error as RepositoryError
            where error.reason == .database(.notFound) {
                try await create(userId: userId)
                return try await get(userId: userId)
            }
        }

        public func create(userId: String) async throws {
            let model = try Settings.Model.create(userId: userId)
            try await DatabaseAccessLayer<Settings.Table>(context: context)
                .insert(
                    .init(
                        id: context.idGenerator.generate(),
                        userId: model.userId,
                        language: model.language,
                        timezone: model.timezone,
                        pageSize: model.pageSize
                    )
                )
        }

        public func update(_ model: Settings.Model) async throws
            -> Settings.Model
        {
            let accessLayer = DatabaseAccessLayer<Settings.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    language: model.language,
                    timezone: model.timezone,
                    pageSize: model.pageSize
                ),
                where: \.userId,
                equals: model.userId
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.userId,
                    equals: model.userId,
                    as: Settings.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func delete(userId: String) async throws {
            try await DatabaseAccessLayer<Settings.Table>(context: context)
                .delete(where: \.userId, equals: userId)
        }
    }
}

extension Settings.Table.Detail {
    fileprivate var asDomain: Settings.Model {
        .init(
            userId: userId,
            language: language,
            timezone: timezone,
            pageSize: pageSize,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
