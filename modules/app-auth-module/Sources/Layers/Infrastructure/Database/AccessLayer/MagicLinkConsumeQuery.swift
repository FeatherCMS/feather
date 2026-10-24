import AuthDomain
import AuthModule
import FeatherDatabase

import struct Foundation.Date

struct MagicLinkConsumeQuery {
    let connection: any DatabaseConnection

    func consume(token: String) async throws -> MagicLink.Model? {
        try await connection.run(
            query: #"""
                UPDATE auth_magic_link
                SET is_used = TRUE, updated_at = NOW()
                WHERE token = \#(token)
                  AND is_used = FALSE
                  AND expires_at > NOW()
                RETURNING *;
                """#
        ) { rows in
            guard let row = try await rows.collect().first else {
                return nil
            }
            return try MagicLink.Model(
                id: row.decode(column: "id", as: String.self),
                authEmailId: row.decode(column: "auth_email_id", as: String.self),
                token: row.decode(column: "token", as: String.self),
                expiresAt: row.decode(column: "expires_at", as: Date.self),
                isPersistent: row.decode(column: "is_persistent", as: Bool.self),
                isUsed: row.decode(column: "is_used", as: Bool.self),
                createdAt: row.decode(column: "created_at", as: Date.self),
                updatedAt: row.decode(column: "updated_at", as: Date.self)
            )
        }
    }
}
