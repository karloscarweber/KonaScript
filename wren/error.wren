// error.wren

// Implements a lightweight wrapper to post errors

class Error {
  // failure(_)
  // Aborts the current fiber and posts an error message
  static failure(message) { Fiber.abort("[Error]: %(message)") }
}
