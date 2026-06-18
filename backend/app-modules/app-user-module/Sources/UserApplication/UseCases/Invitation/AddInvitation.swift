import Application
import Domain
import UserDomain
import struct Foundation.Date

public struct AddInvitation: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Invitations.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitation>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitation>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let email: String

        public init(email: String) {
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
            try await context.invitation.insert(
                Invitation.create(
                    id: idGenerator.generate(),
                    email: input.email,
                    token: generateToken()
                )
            )
        }
        return model.asDetail
    }
}
