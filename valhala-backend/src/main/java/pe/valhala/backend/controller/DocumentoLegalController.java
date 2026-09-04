package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import pe.valhala.backend.entity.DocumentoLegal;
import pe.valhala.backend.repository.DocumentoLegalRepository;
import pe.valhala.backend.repository.EquipoRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.time.LocalDate;
import java.util.List;
@RestController
@RequestMapping("/api/v1/documentos")
public class DocumentoLegalController {
    private final DocumentoLegalRepository repo;
    private final EquipoRepository eqRepo;
    private final UsuarioRepository usrRepo;
    public DocumentoLegalController(DocumentoLegalRepository repo, EquipoRepository eqRepo, UsuarioRepository usrRepo) {
        this.repo = repo; this.eqRepo = eqRepo; this.usrRepo = usrRepo;
    }
    @Data public static class DocDTO { private Long idEquipo; private String tipoPoliza; private String numeroPoliza; private LocalDate fechaVencimiento; }
    private Integer empresaActual() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return usrRepo.findByEmail(email).map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
    }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<DocumentoLegal> listar() {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) return repo.findByIdEmpresa(idEmpresa);
        return repo.findAll();
    }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DocumentoLegal> crear(@RequestBody DocDTO d) {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) {
            var equipo = eqRepo.findById(d.getIdEquipo()).orElseThrow();
            if (equipo.getEmpresa() != null && !equipo.getEmpresa().getIdEmpresa().equals(idEmpresa)) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "El equipo pertenece a otra empresa");
            }
        }
        DocumentoLegal doc = new DocumentoLegal();
        doc.setEquipo(eqRepo.findById(d.getIdEquipo()).orElseThrow());
        doc.setTipoPoliza(d.getTipoPoliza());
        doc.setNumeroPoliza(d.getNumeroPoliza());
        doc.setFechaVencimiento(d.getFechaVencimiento());
        doc.setEstadoLegal("VIGENTE");
        return ResponseEntity.ok(repo.save(doc));
    }
}