public import AuthModule

extension AuthModule {
    public enum Auth {}
}

extension AuthModule.Auth {
    public enum Authorization {}
    public enum CurrentUser {}
    public enum SignIn {}
    public enum TokenAuth {}
}

extension AuthModule.Auth.SignIn {
    public enum Credentials {}
    public enum MagicLink {}
}
