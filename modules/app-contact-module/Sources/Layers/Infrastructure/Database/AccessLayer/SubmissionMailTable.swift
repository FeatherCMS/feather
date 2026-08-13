import ContactDomain
import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension SubmissionMailTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        formId = try row.decode(column: "form_id", as: String.self)
        mailFrom = try row.decode(column: "mail_from", as: String.self)
        mailTo = try row.decode(column: "mail_to", as: String.self)
        subject = try row.decode(column: "subject", as: String.self)
        additionalHeaders = try row.decode(
            column: "additional_headers",
            as: String.self
        )
        messageBody = try row.decode(column: "message_body", as: String.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct SubmissionMailTable {
    struct Row {
        let id: String
        let formId: String
        let mailFrom: String
        let mailTo: String
        let subject: String
        let additionalHeaders: String
        let messageBody: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(formId: String) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM contact_form_mail
                WHERE form_id = \#(formId)
                ORDER BY id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func create(
        model: SubmissionMail.New,
        id: String
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO contact_form_mail (
                    id, form_id, mail_from, mail_to, subject,
                    additional_headers, message_body, created_at, updated_at
                ) VALUES (
                    \#(id), \#(model.formId), \#(model.mailFrom), \#(model.mailTo),
                    \#(model.subject), \#(model.additionalHeaders), \#(model.messageBody), NOW(), NOW()
                ) RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(formId: String) async throws {
        try await connection.run(
            query: #"DELETE FROM contact_form_mail WHERE form_id = \#(formId);"#
        ) { _ in }
    }
}
