import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserContracts
import UserDomain

//
//  AddRole.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRole>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRole>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: RoleCreate
    ) async throws -> RoleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            try await scope.role.insert(
                Role.create(
                    id: input.id,
                    name: input.name,
                    notes: input.notes
                )
            )
        }

        return model.asDetail
    }
}
