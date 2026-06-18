import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension WebMetadataTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.referenceType = try row.decode(
            column: "reference_type",
            as: String?.self
        )
        self.referenceID = try row.decode(
            column: "reference_id",
            as: String?.self
        )
        self.slug = try row.decode(column: "slug", as: String.self)
        self.publicationDate = try row.decode(
            column: "publication_date",
            as: Date?.self
        )
        self.expirationDate = try row.decode(
            column: "expiration_date",
            as: Date?.self
        )
        self.status = try row.decode(column: "status", as: String.self)
        self.titleOverride = try row.decode(
            column: "title_override",
            as: String?.self
        )
        self.excerptOverride = try row.decode(
            column: "excerpt_override",
            as: String?.self
        )
        self.imageURLOverride = try row.decode(
            column: "image_url_override",
            as: String?.self
        )
        self.canonicalURL = try row.decode(
            column: "canonical_url",
            as: String.self
        )
        self.noIndex = try row.decode(column: "no_index", as: Bool.self)
        self.primaryKeyword = try row.decode(
            column: "primary_keyword",
            as: String.self
        )
        self.cssCodeInjection = try row.decode(
            column: "css_code_injection",
            as: String.self
        )
        self.javascriptCodeInjection = try row.decode(
            column: "javascript_code_injection",
            as: String.self
        )
        self.structuredDataCodeInjection = try row.decode(
            column: "structured_data_code_injection",
            as: String.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct WebMetadataTable {

    struct Row {

        struct Create {
            let id: String
            let referenceType: String?
            let referenceID: String?
            let slug: String
            let publicationDate: Date?
            let expirationDate: Date?
            let status: String
            let titleOverride: String?
            let excerptOverride: String?
            let imageURLOverride: String?
            let canonicalURL: String
            let noIndex: Bool
            let primaryKeyword: String
            let cssCodeInjection: String
            let javascriptCodeInjection: String
            let structuredDataCodeInjection: String
        }

        let id: String
        let referenceType: String?
        let referenceID: String?
        let slug: String
        let publicationDate: Date?
        let expirationDate: Date?
        let status: String
        let titleOverride: String?
        let excerptOverride: String?
        let imageURLOverride: String?
        let canonicalURL: String
        let noIndex: Bool
        let primaryKeyword: String
        let cssCodeInjection: String
        let javascriptCodeInjection: String
        let structuredDataCodeInjection: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO web_metadata (
                    id,
                    reference_type,
                    reference_id,
                    slug,
                    publication_date,
                    expiration_date,
                    status,
                    title_override,
                    excerpt_override,
                    image_url_override,
                    canonical_url,
                    no_index,
                    primary_keyword,
                    css_code_injection,
                    javascript_code_injection,
                    structured_data_code_injection,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.referenceType),
                    \#(row.referenceID),
                    \#(row.slug),
                    CASE WHEN \#(row.publicationDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.publicationDate?.timeIntervalSince1970 ?? 0)) END,
                    CASE WHEN \#(row.expirationDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.expirationDate?.timeIntervalSince1970 ?? 0)) END,
                    \#(row.status),
                    \#(row.titleOverride),
                    \#(row.excerptOverride),
                    \#(row.imageURLOverride),
                    \#(row.canonicalURL),
                    \#(row.noIndex),
                    \#(row.primaryKeyword),
                    \#(row.cssCodeInjection),
                    \#(row.javascriptCodeInjection),
                    \#(row.structuredDataCodeInjection),
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

    func list(
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_metadata
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(reference_type, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(reference_id, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(slug) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(title_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(excerpt_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(image_url_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(canonical_url) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(primary_keyword) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM web_metadata
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(reference_type, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(reference_id, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(slug) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(title_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(excerpt_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(image_url_override, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(canonical_url) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(primary_keyword) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_metadata
                WHERE id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(
        slug: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_metadata
                WHERE slug=\#(slug)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(
        referenceType: String,
        referenceID: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_metadata
                WHERE reference_type=\#(referenceType)
                    AND reference_id=\#(referenceID)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(
        referenceType: String,
        slug: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM web_metadata
                WHERE reference_type=\#(referenceType)
                    AND slug=\#(slug)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE web_metadata
                SET
                    slug=\#(row.slug),
                    reference_type=\#(row.referenceType),
                    reference_id=\#(row.referenceID),
                    publication_date=CASE WHEN \#(row.publicationDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.publicationDate?.timeIntervalSince1970 ?? 0)) END,
                    expiration_date=CASE WHEN \#(row.expirationDate == nil) THEN NULL ELSE TO_TIMESTAMP(\#(row.expirationDate?.timeIntervalSince1970 ?? 0)) END,
                    status=\#(row.status),
                    title_override=\#(row.titleOverride),
                    excerpt_override=\#(row.excerptOverride),
                    image_url_override=\#(row.imageURLOverride),
                    canonical_url=\#(row.canonicalURL),
                    no_index=\#(row.noIndex),
                    primary_keyword=\#(row.primaryKeyword),
                    css_code_injection=\#(row.cssCodeInjection),
                    javascript_code_injection=\#(row.javascriptCodeInjection),
                    structured_data_code_injection=\#(row.structuredDataCodeInjection),
                    updated_at=NOW()
                WHERE id=\#(id)
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
                DELETE FROM web_metadata WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }

    func delete(
        referenceType: String,
        referenceID: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM web_metadata
                WHERE reference_type=\#(referenceType)
                    AND reference_id=\#(referenceID)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
