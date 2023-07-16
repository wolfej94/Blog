import Fluent
import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
        users.get(use: index)
        users.group(":id") { user in
            user.get(use: index)
        }
        users.group("user") { user in
            user.get(use: currentUser)
            user.delete(use: delete)
        }
    }

    struct IndexResponse: Content {
        var user: User.Response?
        var users: [User.Response]?
    }
    func index(req: Request) async throws -> IndexResponse {
        try req.auth.require(User.self)
        guard let id = req.parameters.get("id"), let uid = UUID(uuidString: id) else {
            let users = try await User.query(on: req.db).all().map { $0.response }
            return .init(users: users)
        }
        guard let user = try await User.find(uid, on: req.db) else {
            throw Abort(.notFound)
        }
        return .init(user: user.response)
    }

    func create(req: Request) async throws -> User {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        return user
    }
    
    func get(req: Request) async throws -> User {
        try req.auth.require(User.self)
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        try await user.delete(on: req.db)
        return .noContent
    }
    
    func currentUser(req: Request) async throws -> User {
        return try req.auth.require(User.self)
    }
    
}
