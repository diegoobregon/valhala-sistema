package pe.valhala.backend.exception;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import pe.valhala.backend.security.CredencialesInvalidasException;
import java.util.Map;
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler({ColisionReservaException.class, FraudeHorometroException.class, DocumentoVencidoException.class})
    public ResponseEntity<Map<String, String>> negocio(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", e.getClass().getSimpleName(), "message", e.getMessage()));
    }
    @ExceptionHandler(CredencialesInvalidasException.class)
    public ResponseEntity<Map<String, String>> auth(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", e.getMessage()));
    }
    @ExceptionHandler(EmailNoVerificadoException.class)
    public ResponseEntity<Map<String, String>> emailNoVerificado(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", e.getMessage()));
    }
    @ExceptionHandler(EmpresaNoVerificadaException.class)
    public ResponseEntity<Map<String, String>> empresaNoVerificada(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", e.getMessage()));
    }
}