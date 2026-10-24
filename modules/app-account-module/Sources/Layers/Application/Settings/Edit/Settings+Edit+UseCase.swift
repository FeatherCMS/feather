import AccountDomain
public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

//
//  EditSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

extension Settings.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Settings.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Settings.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Settings.Edit.Input
        ) async throws -> Output {
            let userId = input.userId ?? subject.id
            let action = Action(userID: userId)
            guard try await authorizer.can(subject: subject, perform: action)
            else {
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
            return .init(
                userId: model.userId,
                language: model.language,
                timezone: model.timezone,
                pageSize: model.pageSize,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
