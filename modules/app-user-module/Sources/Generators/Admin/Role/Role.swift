import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

public enum Role {
    public enum Post {}
    public enum Delete {}
    public enum List {}
    public enum Query {}
    public enum Get {}
    public enum Put {}
    public enum Patch {}
    public enum ID {}
    public enum Schemas {}
    public enum Parameters {}
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
