import NewsletterDomain
import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension NewsletterCampaignTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.fromEmail = try row.decode(column: "from_email", as: String.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct NewsletterCampaignTable {

    struct Row {

        struct Create {
            let id: String
            let name: String
            let fromEmail: String
        }

        let id: String
        let name: String
        let fromEmail: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO newsletter_campaign (
                    id,
                    name,
                    from_email,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.name),
                    \#(row.fromEmail),
                    NOW(),
                    NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM newsletter_campaign
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { sequence in
            try await sequence.collect().first.map { try Row(from: $0) }
        }
    }

    func list() async throws -> [Row] {
        try await connection.run(
            query:
                #"SELECT * FROM newsletter_campaign ORDER BY name ASC, id ASC;"#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(
        id: String,
        name: String,
        fromEmail: String
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE newsletter_campaign
                SET name = \#(name), from_email = \#(fromEmail), updated_at = NOW()
                WHERE id = \#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM newsletter_campaign
                WHERE id = \#(id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
