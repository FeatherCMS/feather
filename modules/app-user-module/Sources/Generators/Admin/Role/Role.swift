import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

public enum Role {










}

extension Role {
    struct Tag: TagRepresentable {
        var name: String { "UserRoles" }
        var description: String? { "Manage user roles." }
    }
    }

    extension Role.Parameters {
    struct ID: PathParameterRepresentable {
        var name: String { "userRoleId" }
        var description: String? { "UserRole id" }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.ID().reference()
        }
    }
}
