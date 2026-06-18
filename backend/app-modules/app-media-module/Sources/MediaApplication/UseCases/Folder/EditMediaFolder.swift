import Application
import Foundation
import MediaDomain

public struct EditMediaFolder: UseCase {
    public enum Error: UseCaseError {
        case invalidName
        case notFound
    }

    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.update
    }

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

        public init(
            id: String,
            name: String
        ) {
            self.id = id
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
        guard !trimmed.isEmpty else {
            throw Error.invalidName
        }

        return try await transaction.run { context in
            guard var folder = try await context.folders.find(id: input.id)
            else {
                throw Error.notFound
            }
            folder.name = trimmed
            return try await context.folders.update(folder).asDetail
        }
    }
}
