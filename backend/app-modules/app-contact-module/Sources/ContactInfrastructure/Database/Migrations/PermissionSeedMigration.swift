import FeatherDatabase
import Infrastructure

public struct PermissionSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            INSERT INTO system_permission (id, name, notes, created_at, updated_at)
            VALUES
                ('contact:forms:create', 'contact:forms:create', 'Create a contact form.', NOW(), NOW()),
                ('contact:forms:read', 'contact:forms:read', 'View a contact form.', NOW(), NOW()),
                ('contact:forms:update', 'contact:forms:update', 'Edit a contact form.', NOW(), NOW()),
                ('contact:forms:list', 'contact:forms:list', 'List contact forms.', NOW(), NOW()),
                ('contact:forms:delete', 'contact:forms:delete', 'Delete a contact form.', NOW(), NOW()),
                ('contact:form-items:create', 'contact:form-items:create', 'Create a contact form field.', NOW(), NOW()),
                ('contact:form-items:read', 'contact:form-items:read', 'View a contact form field.', NOW(), NOW()),
                ('contact:form-items:update', 'contact:form-items:update', 'Edit a contact form field.', NOW(), NOW()),
                ('contact:form-items:list', 'contact:form-items:list', 'List contact form fields.', NOW(), NOW()),
                ('contact:form-items:delete', 'contact:form-items:delete', 'Delete a contact form field.', NOW(), NOW()),
                ('contact:form-submissions:read', 'contact:form-submissions:read', 'View a contact form submission.', NOW(), NOW()),
                ('contact:form-submissions:update', 'contact:form-submissions:update', 'Update a contact form submission.', NOW(), NOW()),
                ('contact:form-submissions:list', 'contact:form-submissions:list', 'List contact form submissions.', NOW(), NOW()),
                ('contact:form-submissions:delete', 'contact:form-submissions:delete', 'Delete a contact form submission.', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            #"""
            INSERT INTO auth_role_permission (role_id, permission_id, created_at, updated_at)
            SELECT 'root', id, NOW(), NOW()
            FROM system_permission
            WHERE id LIKE 'contact:%'
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
