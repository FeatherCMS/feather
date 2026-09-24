public import FeatherApplication
public import FeatherContracts
import Foundation
import MediaContracts
import MediaDomain

public struct EditMediaFolder: UseCase {
    public enum Error: UseCaseError {
        case invalidName, notFound, duplicatePath
    }
    struct Action: PermissionAction { let key = MediaPermissions.Assets.update }
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
        public let id: String
        public let name: String
        public init(id: String, name: String) {
            self.id = id
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
            guard var folder = try await scope.folders.find(id: input.id) else {
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
            let slugPath = parentPath.map { "\($0)/\(slug)" } ?? slug
            if slugPath != folder.slugPath,
                try await scope.folders.find(slugPath: slugPath) != nil
            {
                throw Error.duplicatePath
            }
            folder.name = name
            folder.slug = slug
            folder.slugPath = slugPath
            return try await scope.folders.update(folder).asDetail
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
