public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Asset.Folder.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await transaction.run { scope in
                guard var folder = try await scope.folders.find(id: input.id)
                else {
                    throw Error.notFound
                }
                let previousParentId = folder.parentId
                let parentId = input.parentId.apply(to: previousParentId)
                if parentId == folder.id {
                    throw Error.duplicatePath
                }
                let parent: Asset.Folder.Model?
                if let parentId {
                    guard let found = try await scope.folders.find(id: parentId)
                    else {
                        throw Error.parentNotFound
                    }
                    parent = found
                    if try await scope.folders
                        .listDescendants(slugPath: folder.slugPath)
                        .contains(where: { $0.id == parentId })
                    {
                        throw Error.duplicatePath
                    }
                }
                else {
                    parent = nil
                }
                let parentPath: String?
                parentPath = parent?.slugPath
                let previousSlugPath = folder.slugPath
                do {
                    try folder.update(
                        name: input.name,
                        parentId: parentId,
                        parentPath: parentPath
                    )
                }
                catch {
                    throw Error.invalidName
                }
                if folder.slugPath != previousSlugPath,
                    try await scope.folders.find(slugPath: folder.slugPath)
                        != nil
                {
                    throw Error.duplicatePath
                }
                let updated = try await scope.folders.update(folder)
                if previousParentId != updated.parentId {
                    var oldParentId = previousParentId
                    var oldParent: Asset.Folder.Model?
                    while let id = oldParentId {
                        oldParent = try await scope.folders.find(id: id)
                        guard let current = oldParent else { break }
                        var changed = current
                        changed.updateAggregates(
                            assetCountDelta: -folder.assetCount,
                            totalSizeBytesDelta: -folder.totalSizeBytes
                        )
                        _ = try await scope.folders.update(changed)
                        oldParentId = current.parentId
                    }
                    var newParentId = updated.parentId
                    while let id = newParentId,
                        let current = try await scope.folders.find(id: id)
                    {
                        var changed = current
                        changed.updateAggregates(
                            assetCountDelta: folder.assetCount,
                            totalSizeBytesDelta: folder.totalSizeBytes
                        )
                        _ = try await scope.folders.update(changed)
                        newParentId = current.parentId
                    }
                }
                return .init(
                    id: updated.id,
                    parentId: updated.parentId,
                    name: updated.name,
                    slug: updated.slug,
                    slugPath: updated.slugPath,
                    assetCount: updated.assetCount,
                    totalSizeBytes: updated.totalSizeBytes,
                    createdAt: updated.createdAt,
                    updatedAt: updated.updatedAt
                )
            }
        }
    }
}
