import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ListIdentityEmails: UseCase {
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
    public func execute(subject: Subject) async throws -> [IdentityEmailDetail]
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.identityEmail.list().map(IdentityEmailDetail.init)
        }
    }
}

public struct AddIdentityEmail: UseCase {
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
        public let isPrimary: Bool
        public let isVerified: Bool
        public init(
            identityId: String,
            email: String,
            isPrimary: Bool,
            isVerified: Bool
        ) {
            self.identityId = identityId
            self.email = email
            self.isPrimary = isPrimary
            self.isVerified = isVerified
        }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> IdentityEmailDetail
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        let model = try await transaction.run { scope in
            try await scope.identityEmail.insert(
                identityId: input.identityId,
                email: input.email
            )
        }
        return .init(model)
    }
}

public struct EditIdentityEmail: UseCase {
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
        public let isPrimary: Bool
        public let isVerified: Bool
        public init(
            id: String,
            identityId: String,
            email: String,
            isPrimary: Bool,
            isVerified: Bool
        ) {
            self.id = id
            self.identityId = identityId
            self.email = email
            self.isPrimary = isPrimary
            self.isVerified = isVerified
        }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> IdentityEmailDetail
    {
        guard try await authorizer.can(subject: subject, perform: Action())
        else {
            throw AuthError(kind: .forbidden, message: Action().key.rawValue)
        }
        let model = try await transaction.run { scope in
            guard let model = try await scope.identityEmail.findBy(id: input.id)
            else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Identity email not found",
                    userFriendlyMessage: "Identity email not found"
                )
            }
            var updated = model
            updated.identityId = input.identityId
            updated.email = input.email
            updated.isPrimary = input.isPrimary
            updated.isVerified = input.isVerified
            return try await scope.identityEmail.update(updated)
        }
        return .init(model)
    }
}

public struct RemoveIdentityEmails: UseCase {
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
            try await scope.identityEmail.delete(ids: ids)
        }
    }
}
