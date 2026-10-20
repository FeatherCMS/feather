public import FeatherApplication
public import FeatherModuleKit
public import UserDomain
public import UserModule

//
//  Role.Edit.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Role.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Role.Permissions.update
        }

        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Role.Repository.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Role.Repository.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Role.Edit.Input
        ) async throws -> Role.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                guard var model = try await scope.role.findBy(id: input.id)
                else {
                    throw Error(message: "Role not found")
                }

                try model.update(
                    name: input.name,
                    notes: input.notes
                )

                return try await scope.role.update(model)
            }

            return model.asDetail
        }
    }

}
