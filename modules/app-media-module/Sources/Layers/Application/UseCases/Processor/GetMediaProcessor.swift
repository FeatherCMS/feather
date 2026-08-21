import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

//
//  GetMediaProcessor.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct GetMediaProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Processors.read
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public init(id: String) { self.id = id }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaProcessorDetail? {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.processors.find(id: input.id)?.asProcessorDetail
        }
    }
}
