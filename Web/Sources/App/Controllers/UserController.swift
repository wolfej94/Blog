import Fluent
import Vapor
import Logic

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
        users.get(use: getAll)
        users.group(":id") { user in
            user.get(use: getByID)
        }
        users.group("user") { user in
            user.get(use: currentUser)
            user.delete(use: delete)
        }
    }
    
    func getAll(req: Request) async throws -> [UserResponse] {
        try req.auth.require(User.self)
        let users = try await User.query(on: req.db).all().map { $0.response }
        return users
    }
    
    func getByID(req: Request) async throws -> UserResponse {
        try req.auth.require(User.self)
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.response
    }

    func create(req: Request) async throws -> UserToken {
        try UserRequest.validate(content: req)
        let create = try req.content.decode(UserRequest.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return token
    }
    
    func get(req: Request) async throws -> UserResponse {
        try req.auth.require(User.self)
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.response
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        try await user.delete(on: req.db)
        return .noContent
    }
    
    func currentUser(req: Request) async throws -> UserResponse {
        return try req.auth.require(User.self).response
    }
    
}
