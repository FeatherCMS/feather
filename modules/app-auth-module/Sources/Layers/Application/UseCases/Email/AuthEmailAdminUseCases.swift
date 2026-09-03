import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ListAuthEmails: UseCase {
    struct Action: PermissionAction { let key = AuthPermissions.Emails.list }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuth>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuth>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public func execute(subject: Subject) async throws -> [AuthEmailDetail] {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.authEmail.list().map(AuthEmailDetail.init)
        }
    }
}

public struct AddAuthEmail: UseCase {
    struct Action: PermissionAction { let key = AuthPermissions.Emails.create }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuth>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuth>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let identityId: String
        public let email: String
        public init(
            identityId: String,
            email: String
        ) {
            self.identityId = identityId
            self.email = email
        }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> AuthEmailDetail
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        let model = try await transaction.run { scope in
            try await scope.authEmail.insert(
                identityId: input.identityId,
                email: input.email
            )
        }
        return .init(model)
    }
}

public struct EditAuthEmail: UseCase {
    struct Action: PermissionAction { let key = AuthPermissions.Emails.update }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuth>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuth>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public let identityId: String
        public let email: String
        public init(
            id: String,
            identityId: String,
            email: String
        ) {
            self.id = id
            self.identityId = identityId
            self.email = email
        }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> AuthEmailDetail
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        let model = try await transaction.run { scope in
            guard let model = try await scope.authEmail.findBy(id: input.id)
            else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Auth email not found",
                    userFriendlyMessage: "Auth email not found"
                )
            }
            var updated = model
            updated.identityId = input.identityId
            updated.email = input.email
            return try await scope.authEmail.update(updated)
        }
        return .init(model)
    }
}

public struct RemoveAuthEmails: UseCase {
    struct Action: PermissionAction { let key = AuthPermissions.Emails.delete }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuth>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuth>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public func execute(subject: Subject, ids: [String]) async throws
        -> [String]
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.authEmail.delete(ids: ids)
        }
    }
}
