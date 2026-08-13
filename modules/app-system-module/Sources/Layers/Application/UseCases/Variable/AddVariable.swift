//
//  AddVariable.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import SystemDomain

public struct AddVariable: UseCase {

    struct Action: PermissionAction {
        let key = SystemPermissions.Variables.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteVariable>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteVariable>,
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let value: String
        public let name: String?
        public let notes: String?

        public init(
            id: String,
            value: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.name = name
            self.value = value
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> VariableDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let value = input.value
        let name = input.name
        let notes = input.notes

        let model = try await transaction.run { scope in
            try await scope.variable.insert(
                Variable.create(
                    id: input.id,
                    value: value,
                    name: name,
                    notes: notes
                )
            )
        }
        return model.asDetail
    }
}
