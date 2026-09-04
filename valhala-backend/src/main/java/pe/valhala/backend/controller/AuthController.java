package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.*;
import pe.valhala.backend.service.AuthService;
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    private final AuthService authService;
    public AuthController(AuthService authService) { this.authService = authService; }
    @PostMapping("/login") public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest r) { return ResponseEntity.ok(authService.login(r)); }
    @PostMapping("/registro") public ResponseEntity<RegistroResponse> registrar(@Valid @RequestBody RegistroRequest r) { return ResponseEntity.ok(authService.registrar(r)); }
    @PostMapping("/verificar") public ResponseEntity<VerificarResponse> verificar(@Valid @RequestBody VerificarRequest r) { return ResponseEntity.ok(authService.verificar(r)); }
}