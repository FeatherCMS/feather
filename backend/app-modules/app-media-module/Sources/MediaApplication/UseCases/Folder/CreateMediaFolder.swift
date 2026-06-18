import Application
import Foundation
import MediaDomain

public struct CreateMediaFolder: UseCase {
    public enum Error: UseCaseError {
        case invalidName
        case parentNotFound
        case duplicatePath
    }

    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let parentId: String?
        public let name: String

        public init(parentId: String?, name: String) {
            self.parentId = parentId
            self.name = name
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaFolderDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let trimmed = input.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let slug = normalizedPathComponent(from: trimmed)
        guard !trimmed.isEmpty, !slug.isEmpty else {
            throw Error.invalidName
        }

        return try await transaction.run { context in
            let parent = try await resolveParent(
                id: input.parentId,
                folders: context.folders
            )
            let path =
                parent.map { "\($0.path)/\(slug)" }
                ?? slug

            if try await context.folders.find(path: path) != nil {
                throw Error.duplicatePath
            }

            return try await context.folders
                .insert(
                    MediaFolder.create(
                        id: idGenerator.generate(),
                        parentId: parent?.id,
                        name: trimmed,
                        path: path
                    )
                )
                .asDetail
        }
    }

    private func resolveParent(
        id: String?,
        folders: any MediaFolderRepository
    ) async throws -> MediaFolder? {
        guard let id else { return nil }
        guard let parent = try await folders.find(id: id) else {
            throw Error.parentNotFound
        }
        return parent
    }
}

private func normalizedPathComponent(
    from value: String
) -> String {
    value
        .lowercased()
        .replacingOccurrences(
            of: #"[^a-z0-9]+"#,
            with: "-",
            options: .regularExpression
        )
        .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
}
