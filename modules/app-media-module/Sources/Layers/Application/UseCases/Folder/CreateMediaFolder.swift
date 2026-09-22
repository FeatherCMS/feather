import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import MediaContracts
import MediaDomain

public struct CreateMediaFolder: UseCase {
    public enum Error: UseCaseError {
        case invalidName, parentNotFound, duplicatePath
    }
    struct Action: PermissionAction { let key = MediaPermissions.Assets.create }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let parentId: String?
        public let name: String
        public init(parentId: String?, name: String) {
            self.parentId = parentId
            self.name = name
        }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaFolderDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let name = input.name.whitespaceTrimmed
        let slug = normalizedSlug(name)
        guard !name.isEmpty, !slug.isEmpty else { throw Error.invalidName }
        return try await transaction.run { scope in
            let parent: MediaAssetNodeFolder?
            if let parentId = input.parentId {
                parent = try await scope.folders.find(id: parentId)
                if parent == nil { throw Error.parentNotFound }
            }
            else {
                parent = nil
            }
            let slugPath = parent.map { "\($0.slugPath)/\(slug)" } ?? slug
            if try await scope.folders.find(slugPath: slugPath) != nil {
                throw Error.duplicatePath
            }
            return try await scope.folders
                .insert(
                    MediaAssetNodeFolder.create(
                        parentId: parent?.id,
                        name: name,
                        slug: slug,
                        slugPath: slugPath
                    )
                )
                .asDetail
        }
    }
}

private func normalizedSlug(_ value: String) -> String {
    value.lowercased()
        .replacingOccurrences(
            of: "[^a-z0-9]+",
            with: "-",
            options: .regularExpression
        )
        .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
}
