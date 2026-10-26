public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Asset.Folder.Add {
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
                let parent: Asset.Folder.Model?
                if let parentId = input.parentId {
                    parent = try await scope.folders.find(id: parentId)
                    if parent == nil {
                        throw Error.parentNotFound
                    }
                }
                else {
                    parent = nil
                }
                let newFolder: Asset.Folder.Model.New
                do {
                    newFolder = try Asset.Folder.Model.create(
                        parentId: parent?.id,
                        name: input.name,
                        parentPath: parent?.slugPath
                    )
                }
                catch {
                    throw Error.invalidName
                }
                let existing = try await scope.folders.find(
                    slugPath: newFolder.slugPath
                )
                if existing != nil {
                    throw Error.duplicatePath
                }
                let folder = try await scope.folders.insert(newFolder)
                return .init(
                    id: folder.id,
                    parentId: folder.parentId,
                    name: folder.name,
                    slug: folder.slug,
                    slugPath: folder.slugPath,
                    assetCount: folder.assetCount,
                    totalSizeBytes: folder.totalSizeBytes,
                    createdAt: folder.createdAt,
                    updatedAt: folder.updatedAt
                )
            }
        }
    }
}
