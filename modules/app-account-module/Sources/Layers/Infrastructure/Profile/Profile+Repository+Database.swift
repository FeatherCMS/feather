public import AccountDomain
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Profile.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func get(userId: String) async throws -> Profile.Model {
            guard
                let detail = try await DatabaseAccessLayer<
                    Profile.Table
                >(
                    context: context
                )
                .selectFirst(
                    by: \.userId,
                    equals: userId,
                    as: Profile.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func getOrCreate(userId: String) async throws
            -> Profile.Model
        {
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
            let model = try Profile.Model.create(userId: userId)
            try await DatabaseAccessLayer<Profile.Table>(
                context: context
            )
            .insert(
                .init(
                    id: context.idGenerator.generate(),
                    userId: model.userId,
                    firstName: model.firstName,
                    lastName: model.lastName,
                    profileImageAssetId: model.profileImageAssetId
                )
            )
        }

        public func update(_ model: Profile.Model) async throws
            -> Profile.Model
        {
            let accessLayer = DatabaseAccessLayer<Profile.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    firstName: model.firstName,
                    lastName: model.lastName,
                    profileImageAssetId: model.profileImageAssetId
                ),
                where: \.userId,
                equals: model.userId
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.userId,
                    equals: model.userId,
                    as: Profile.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func delete(userId: String) async throws {
            try await DatabaseAccessLayer<Profile.Table>(
                context: context
            )
            .delete(where: \.userId, equals: userId)
        }
    }
    }

    extension Profile.Table.Detail {
    fileprivate var asDomain: Profile.Model {
        .init(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
