import Fluent
import Vapor

func routes(_ app: Application) throws {
    let basicProtected = app.grouped(User.authenticator())
    try basicProtected.register(collection: AuthController())
    let tokenProtected = app.grouped(UserToken.authenticator())
    try tokenProtected.register(collection: UserController())
    try tokenProtected.register(collection: PostController())
}
