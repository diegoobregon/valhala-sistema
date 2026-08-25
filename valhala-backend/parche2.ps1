$base = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\java\pe\valhala\backend"
$utf8 = New-Object System.Text.UTF8Encoding $false

[System.IO.File]::WriteAllText("$base\controller\CheckOutController.java", @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.CheckOutRequest;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.service.CheckOutService;

@RestController
@RequestMapping("/api/v1/transacciones/checkout")
public class CheckOutController {
    private final CheckOutService service;
    private final UsuarioRepository usuarioRepo;
    public CheckOutController(CheckOutService service, UsuarioRepository usuarioRepo) {
        this.service = service;
        this.usuarioRepo = usuarioRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<CheckOutSalida> despachar(@Valid @RequestBody CheckOutRequest req) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Integer idMecanico = usuarioRepo.findByEmail(email).orElseThrow().getIdUsuario();
        return ResponseEntity.ok(service.despachar(req, idMecanico));
    }
}
'@, $utf8)

[System.IO.File]::WriteAllText("$base\controller\CheckInController.java", @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.CheckInRequest;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.service.CheckInService;

@RestController
@RequestMapping("/api/v1/transacciones/checkin")
public class CheckInController {
    private final CheckInService service;
    private final UsuarioRepository usuarioRepo;
    public CheckInController(CheckInService service, UsuarioRepository usuarioRepo) {
        this.service = service;
        this.usuarioRepo = usuarioRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<LiquidacionFinanciera> retornar(@Valid @RequestBody CheckInRequest req) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Integer idMecanico = usuarioRepo.findByEmail(email).orElseThrow().getIdUsuario();
        return ResponseEntity.ok(service.retornar(req, idMecanico));
    }
}
'@, $utf8)

[System.IO.File]::WriteAllText("$base\exception\GlobalExceptionHandler.java", @'
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
    @ExceptionHandler(ColisionReservaException.class)
    public ResponseEntity<Map<String, Object>> colision(ColisionReservaException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("timestamp", LocalDateTime.now(), "status", 409, "error", e.getMessage()));
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
'@, $utf8)

Write-Host "PARCHE2 APLICADO!"