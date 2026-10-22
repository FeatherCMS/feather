import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import WebDomain

extension MenuItem.Table.Detail {
    var asDomain: MenuItem.Model {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            authentication: MenuItem.Authentication(rawValue: authentication)
                ?? .any,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension MenuItem.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: MenuItem.Model.New
        ) async throws -> MenuItem.Model {
            let accessLayer = DatabaseAccessLayer<MenuItem.Table>(
                context: context
            )
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                MenuItem.Table.Insert(
                    id: id,
                    menuId: model.menuId,
                    label: model.label,
                    url: model.url,
                    priority: model.priority,
                    isBlank: model.isBlank,
                    permission: model.permission,
                    authentication: model.authentication.rawValue,
                    notes: model.notes
                )
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func find(id: String) async throws -> MenuItem.Model? {
            try await DatabaseAccessLayer<MenuItem.Table>(context: context)
                .selectFirst(by: \.id, equals: id)
                .map { $0.asDomain }
        }

        public func update(_ model: MenuItem.Model) async throws
            -> MenuItem.Model
        {
            let accessLayer = DatabaseAccessLayer<MenuItem.Table>(
                context: context
            )
            try await accessLayer.update(
                MenuItem.Table.Update(
                    menuId: model.menuId,
                    label: model.label,
                    url: model.url,
                    priority: model.priority,
                    isBlank: model.isBlank,
                    permission: model.permission,
                    authentication: model.authentication.rawValue,
                    notes: model.notes
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let detail = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return detail.asDomain
        }

        public func move(
            id: String,
            menuId: String,
            beforeItemId: String?
        ) async throws {
            let accessLayer = DatabaseAccessLayer<MenuItem.Table>(
                context: context
            )
            var items = try await accessLayer.select { initial in
                initial
                    .where(\.menuId, equals: menuId)
                    .order(by: [
                        .init(by: \.priority, .ascending),
                        .init(by: \.id, .ascending),
                    ])
            }
            guard let sourceIndex = items.firstIndex(where: { $0.id == id })
            else {
                throw RepositoryError.notFound
            }
            let source = items.remove(at: sourceIndex)
            let destinationIndex =
                beforeItemId.flatMap { targetId in
                    items.firstIndex(where: { $0.id == targetId })
                } ?? items.endIndex
            items.insert(source, at: destinationIndex)

            for (priority, item) in items.enumerated()
            where item.priority != priority {
                try await accessLayer.update(
                    MenuItem.Table.Update(
                        menuId: item.menuId,
                        label: item.label,
                        url: item.url,
                        priority: priority,
                        isBlank: item.isBlank,
                        permission: item.permission,
                        authentication: item.authentication,
                        notes: item.notes
                    ),
                    where: \.id,
                    equals: item.id
                )
            }
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<MenuItem.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
