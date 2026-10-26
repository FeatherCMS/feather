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
                let parentPath: String?
                if let parentId = folder.parentId {
                    parentPath = try await scope.folders.find(id: parentId)?
                        .slugPath
                }
                else {
                    parentPath = nil
                }
                let previousSlugPath = folder.slugPath
                do {
                    try folder.update(
                        name: input.name,
                        parentPath: parentPath
                    )
                }
                catch {
                    throw Error.invalidName
                }
                if folder.slugPath != previousSlugPath,
                    try await scope.folders.find(slugPath: folder.slugPath) != nil
                {
                    throw Error.duplicatePath
                }
                let updated = try await scope.folders.update(folder)
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
