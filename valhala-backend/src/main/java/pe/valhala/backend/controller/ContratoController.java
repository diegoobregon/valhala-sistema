package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Contrato;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import pe.valhala.backend.repository.ContratoRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.time.LocalDate;
import java.util.List;
@RestController @RequestMapping("/api/v1/contratos")
public class ContratoController {
    private final ContratoRepository repo; private final ClienteCorporativoRepository cliRepo; private final UsuarioRepository usrRepo;
    public ContratoController(ContratoRepository repo, ClienteCorporativoRepository cliRepo, UsuarioRepository usrRepo) { this.repo = repo; this.cliRepo = cliRepo; this.usrRepo = usrRepo; }
    @Data public static class ContratoDTO { private Integer idCliente; private LocalDate fechaInicio; private LocalDate fechaFin; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<Contrato> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Contrato> crear(@RequestBody ContratoDTO d) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Contrato c = new Contrato();
        c.setCliente(cliRepo.findById(d.getIdCliente()).orElseThrow());
        c.setUsuarioCreador(usrRepo.findByEmail(email).orElseThrow());
        c.setFechaEmision(LocalDate.now()); c.setFechaInicio(d.getFechaInicio()); c.setFechaFin(d.getFechaFin());
        c.setEstadoContrato("ACTIVO");
        return ResponseEntity.ok(repo.save(c));
    }
}