import Application
import UserDomain

public struct EditInvitation: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Invitations.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitation>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitation>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let email: String?

        public init(
            id: String,
            email: String?
        ) {
            self.id = id
            self.email = email
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> InvitationDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            guard var model = try await context.invitation.findBy(id: input.id)
            else {
                throw Error(message: "Invitation not found")
            }

            try model.update(email: input.email)
            return try await context.invitation.update(model)
        }

        return model.asDetail
    }
}
