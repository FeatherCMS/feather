import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts

//
//  EditSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

public struct EditSettings: UseCase {

    struct Action: PermissionAction {
        let key: PermissionKey

        init(
            subjectID: String,
            userID: String
        ) {
            key = subjectID == userID
                ? AccountPermissions.Settings.update
                : AccountPermissions.Settings.manage
        }
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteSettings>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteSettings>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let language: String
        public let timezone: String
        public let pageSize: Int
        public let userId: String?

        public init(
            language: String,
            timezone: String,
            pageSize: Int,
            userId: String? = nil
        ) {
            self.language = language
            self.timezone = timezone
            self.pageSize = pageSize
            self.userId = userId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let userId = input.userId ?? subject.id
        let action = Action(subjectID: subject.id, userID: userId)
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            var model = try await scope.settings.get(userId: userId)
            try model.update(
                language: input.language,
                timezone: input.timezone,
                pageSize: input.pageSize
            )
            return try await scope.settings.update(model)
        }
        return model.asDetail
    }
}
