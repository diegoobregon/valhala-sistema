package pe.valhala.backend.exception;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import pe.valhala.backend.security.CredencialesInvalidasException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.NoSuchElementException;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(org.springframework.dao.DataIntegrityViolationException.class)
public ResponseEntity<Map<String, Object>> duplicado(org.springframework.dao.DataIntegrityViolationException e) {
    return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of(
        "timestamp", LocalDateTime.now(),
        "status", 409,
        "error", "Registro duplicado: ya existe un dato con ese código único (restricción UNIQUE)."
    ));
}
    @ExceptionHandler(DocumentoVencidoException.class)
    public ResponseEntity<Map<String, Object>> docVencido(DocumentoVencidoException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("timestamp", LocalDateTime.now(), "status", 403, "error", e.getMessage()));
    }
    @ExceptionHandler(FraudeHorometroException.class)
    public ResponseEntity<Map<String, Object>> fraude(FraudeHorometroException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("timestamp", LocalDateTime.now(), "status", 400, "error", e.getMessage()));
    }
    @ExceptionHandler(CredencialesInvalidasException.class)
    public ResponseEntity<Map<String, Object>> credenciales(CredencialesInvalidasException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("timestamp", LocalDateTime.now(), "status", 401, "error", e.getMessage()));
    }
    @ExceptionHandler(NoSuchElementException.class)
    public ResponseEntity<Map<String, Object>> notFound(NoSuchElementException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("timestamp", LocalDateTime.now(), "status", 404, "error", "Recurso no encontrado"));
    }
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> denied(AccessDeniedException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("timestamp", LocalDateTime.now(), "status", 403, "error", "Acceso denegado por rol: " + e.getMessage()));
    }
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> general(Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("timestamp", LocalDateTime.now(), "status", 500, "error", e.getClass().getSimpleName() + ": " + e.getMessage()));
    }
}