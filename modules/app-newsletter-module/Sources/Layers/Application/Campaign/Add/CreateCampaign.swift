public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

public struct CreateCampaign: UseCase {
    struct Action: PermissionAction { let key = Campaign.Permissions.create }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let key: String
        public let name: String
        public let fromEmail: String

        public init(
            key: String,
            name: String,
            fromEmail: String = ""
        ) {
            self.key = key
            self.name = name
            self.fromEmail = fromEmail
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Campaign.Add.Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let model = try Campaign.Model.create(
                key: input.key,
                name: input.name,
                fromEmail: input.fromEmail
            )
            let saved = try await scope.newsletter.insert(model)
            return .init(
                id: saved.id,
                key: saved.key,
                name: saved.name,
                fromEmail: saved.fromEmail,
                createdAt: saved.createdAt,
                updatedAt: saved.updatedAt
            )
        }
    }
}
