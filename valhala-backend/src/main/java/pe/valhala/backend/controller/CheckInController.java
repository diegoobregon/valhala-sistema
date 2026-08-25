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