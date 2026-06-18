import Domain
import struct Foundation.Date

public struct Account: Model {

    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong

        case passwordTooShort
        case passwordTooLong
        case passwordHashTooShort
        case passwordHashTooLong
        case passwordHashRequired
        case passwordRequired
    }

    public struct New: Sendable {
        public let id: String
        public let email: String
        public let password: String
        public let passwordHash: String
        public let status: Status
    }

    public enum Status: String, Sendable, CaseIterable {
        case pending
        case active
        case inactive
    }

    public let id: String
    public var email: String
    public var passwordHash: String
    public var status: Status
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        email: String,
        passwordHash: String,
        status: Status,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Account {

    private static func validate(
        email: String
    ) throws(Self.Error) {
        guard email.count > 3 else {
            throw .emailTooShort
        }
        guard email.count < 255 else {
            throw .emailTooLong
        }
    }

    private static func validate(
        password: String
    ) throws(Self.Error) {
        guard password.count > 8 else {
            throw .passwordTooShort
        }
        guard password.count < 255 else {
            throw .passwordTooLong
        }
    }

    private static func validate(
        passwordHash: String
    ) throws(Self.Error) {
        guard passwordHash.count > 8 else {
            throw .passwordHashTooShort
        }
        guard passwordHash.count < 255 else {
            throw .passwordHashTooLong
        }
    }

    static func create(
        id: String,
        email: String,
        password: String,
        passwordHash: String
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        try validate(password: password)
        try validate(passwordHash: passwordHash)

        return .init(
            id: id,
            email: email,
            password: password,
            passwordHash: passwordHash,
            status: .active
        )
    }

    mutating func update(
        email: String? = nil,
        password: String? = nil,
        passwordHash: String? = nil,
        status: Account.Status? = nil
    ) throws(Self.Error) {
        let newEmail = email ?? self.email
        let newStatus = status ?? self.status

        try Self.validate(email: newEmail)

        self.email = newEmail
        self.status = newStatus

        // TODO: inject password hasher?
        if password != nil, passwordHash == nil {
            throw .passwordHashRequired
        }
        if password == nil, passwordHash != nil {
            throw .passwordRequired
        }
        if let password, let passwordHash {
            try Self.validate(password: password)
            try Self.validate(passwordHash: passwordHash)

            self.passwordHash = passwordHash
        }
    }
}

//enum UserAccountFieldValidator {
//
//    static func email(
//        _ value: String?,
//        required: Bool
//    ) -> Validator<String> {
//        .init(
//            key: "email",
//            value: value,
//            required: required,
//            invocation: .all,
//            rules: [
//                .trimmedNonempty(message: "Email is required."),
//                .email(message: "Email is invalid."),
//            ]
//        )
//    }
//
//    static func password(
//        _ value: String?,
//        required: Bool
//    ) -> Validator<String> {
//        .init(
//            key: "password",
//            value: value,
//            required: required,
//            invocation: .all,
//            rules: [
//                .min(length: 8, message: "Password is too short."),
//                .max(length: 128, message: "Password is too long."),
//            ]
//        )
//    }
//}
//
//public extension UserAccount {
//    static func validateCreate(
//        email: String,
//        password: String
//    ) async throws(ValidationError) {
//        try await GroupValidator {
//            UserAccountFieldValidator.email(email, required: true)
//            UserAccountFieldValidator.password(password, required: true)
//        }
//        .validate()
//    }
//
//    static func validateUpdate(
//        email: String,
//        password: String
//    ) async throws(ValidationError) {
//        try await GroupValidator {
//            UserAccountFieldValidator.email(email, required: true)
//            UserAccountFieldValidator.password(password, required: true)
//        }
//        .validate()
//    }
//
//    static func validatePatch(
//        email: String?,
//        password: String?
//    ) async throws(ValidationError) {
//        try await GroupValidator {
//            UserAccountFieldValidator.email(email, required: false)
//            UserAccountFieldValidator.password(password, required: false)
//        }
//        .validate()
//    }
//}
