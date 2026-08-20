import MediaContracts
//
//  CreateMediaProcessor.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import MediaDomain

public struct CreateMediaProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Processors.create
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
        public let processor: MediaProcessorCreate
        public init(processor: MediaProcessorCreate) {
            self.processor = processor
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaProcessorDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.processors
                .insert(
                    MediaProcessor.create(
                        name: input.processor.name,
                        matchExtensions: input.processor.matchExtensions,
                        commandTemplate: input.processor.commandTemplate,
                        isRequired: false,
                        isActive: true
                    )
                )
                .asProcessorDetail
        }
    }
}
