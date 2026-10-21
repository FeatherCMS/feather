public import AuthModule

extension RolePermission {
    public enum Add {}
    public enum Search {}
    public enum Remove {}
    public enum Lookup {}
}

extension RolePermission.Lookup {
    public enum Query {}
}
