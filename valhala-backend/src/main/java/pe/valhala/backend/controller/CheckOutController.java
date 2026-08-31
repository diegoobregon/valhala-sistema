package pe.valhala.backend.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.CheckOutRequest;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.repository.CheckOutSalidaRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.service.CheckOutService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/transacciones/checkout")
public class CheckOutController {

    private final CheckOutService service;
    private final UsuarioRepository usuarioRepo;
    private final CheckOutSalidaRepository salidaRepo;

    public CheckOutController(CheckOutService service,
                              UsuarioRepository usuarioRepo,
                              CheckOutSalidaRepository salidaRepo) {
        this.service = service;
        this.usuarioRepo = usuarioRepo;
        this.salidaRepo = salidaRepo;
    }

    /** Lista los despachos registrados (alimenta el selector de Check-in en el frontend). */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<CheckOutSalida> listar() {
        return salidaRepo.findAll();
    }

    /** RF-06: despacha el equipo, bloqueando si tiene documentos legales vencidos. */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<CheckOutSalida> despachar(@Valid @RequestBody CheckOutRequest req) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Integer idMecanico = usuarioRepo.findByEmail(email).orElseThrow().getIdUsuario();
        return ResponseEntity.ok(service.despachar(req, idMecanico));
    }
}