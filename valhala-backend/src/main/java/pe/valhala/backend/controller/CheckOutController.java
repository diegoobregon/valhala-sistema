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