import FeatherDatabase
import FeatherInfrastructure
import Foundation

extension AccountProfileTable.Row {
    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.userId = try row.decode(column: "user_id", as: String.self)
        self.firstName = try row.decode(column: "first_name", as: String?.self)
        self.lastName = try row.decode(column: "last_name", as: String?.self)
        self.imageURL = try row.decode(column: "image_url", as: String?.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct AccountProfileTable {
    struct Row {
        struct Create {
            let id: String
            let userId: String
            let firstName: String?
            let lastName: String?
            let imageURL: String?
        }

        struct Update {
            let firstName: String?
            let lastName: String?
            let imageURL: String?
        }

        let id: String
        let userId: String
        let firstName: String?
        let lastName: String?
        let imageURL: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(query: #"""
            INSERT INTO account_profile (
                id, user_id, first_name, last_name, image_url, created_at, updated_at
            ) VALUES (
                \#(row.id), \#(row.userId), \#(row.firstName), \#(row.lastName), \#(row.imageURL), NOW(), NOW()
            ) RETURNING *;
            """#) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func get(
        userId: String
    ) async throws -> Row {
        try await connection.run(query: #"""
            SELECT * FROM account_profile WHERE user_id = \#(userId) LIMIT 1;
            """#) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func update(
        userId: String,
        row: Row.Update
    ) async throws -> Row {
        try await connection.run(query: #"""
            UPDATE account_profile
            SET first_name = \#(row.firstName), last_name = \#(row.lastName),
                image_url = \#(row.imageURL), updated_at = NOW()
            WHERE user_id = \#(userId)
            RETURNING *;
            """#) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
        userId: String
    ) async throws {
        _ = try await connection.run(query: #"""
            DELETE FROM account_profile WHERE user_id = \#(userId);
            """#) { sequence in try await sequence.collect() }
    }
}
