public import AuthDomain
public import AuthModule
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
import SystemDomain
import SystemInfrastructure
import SystemModule

extension RolePermission.Table.Detail {
    func asDomain(permissionKey: String) -> RolePermission.Model {
        .init(
            roleId: roleId,
            permissionId: permissionKey,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension RolePermission.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<RolePermission.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        private func permissionID(forKey key: String) async throws -> String {
            guard
                let permission = try await SystemModule.Permission.Repository
                    .Database(context: context).find(key: key)
            else {
                throw RepositoryError.notFound
            }
            return permission.id
        }

        private func find(roleId: String, permissionId: String) async throws
            -> RolePermission.Table.Detail?
        {
            let filter = DatabaseQueryFilter<RolePermission.Table>()
                .where(\.roleId, equals: roleId)
                .where(\.permissionId, equals: permissionId)
            return try await accessLayer.selectFirst(
                as: RolePermission.Table.Detail.self
            ) {
                $0.where(filter).limit(1)
            }
        }

        public func findBy(roleId: String, permissionId: String) async throws
            -> RolePermission.Model?
        {
            let databasePermissionID = try await permissionID(
                forKey: permissionId
            )
            return try await find(
                roleId: roleId,
                permissionId: databasePermissionID
            )?
            .asDomain(permissionKey: permissionId)
        }

        public func insert(_ model: RolePermission.Model.New) async throws
            -> RolePermission.Model
        {
            let databasePermissionID = try await permissionID(
                forKey: model.permissionId
            )
            try await accessLayer.insert(
                RolePermission.Table.Insert(
                    roleId: model.roleId,
                    permissionId: databasePermissionID
                )
            )
            guard
                let saved = try await find(
                    roleId: model.roleId,
                    permissionId: databasePermissionID
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain(permissionKey: model.permissionId)
        }

        public func update(
            roleId: String,
            permissionId: String,
            _ model: RolePermission.Model.New
        ) async throws -> RolePermission.Model {
            let oldPermissionID = try await permissionID(forKey: permissionId)
            let newPermissionID = try await permissionID(
                forKey: model.permissionId
            )
            let filter = DatabaseQueryFilter<RolePermission.Table>()
                .where(\.roleId, equals: roleId)
                .where(\.permissionId, equals: oldPermissionID)
            try await accessLayer.update(
                RolePermission.Table.Update(permissionId: newPermissionID),
                where: filter
            )
            guard
                let updated = try await find(
                    roleId: roleId,
                    permissionId: newPermissionID
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain(permissionKey: model.permissionId)
        }

        public func delete(ids: [String]) async throws -> [String] {
            for id in ids {
                let parts = id.split(separator: ":", maxSplits: 1)
                    .map(String.init)
                guard parts.count == 2 else { continue }
                let databasePermissionID = try await permissionID(
                    forKey: parts[1]
                )
                let filter = DatabaseQueryFilter<RolePermission.Table>()
                    .where(\.roleId, equals: parts[0])
                    .where(\.permissionId, equals: databasePermissionID)
                try await accessLayer.delete(where: filter)
            }
            return ids
        }
    }
}
