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
        let key = SettingsPermissions.Settings.update
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

        public init(
            language: String,
            timezone: String,
            pageSize: Int
        ) {
            self.language = language
            self.timezone = timezone
            self.pageSize = pageSize
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            var model = try await scope.settings.get(userId: subject.id)
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
