package pe.valhala.backend.controller;

import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.DocumentoLegal;
import pe.valhala.backend.repository.DocumentoLegalRepository;
import pe.valhala.backend.repository.EquipoRepository;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/documentos")
public class DocumentoLegalController {

    private final DocumentoLegalRepository repo;
    private final EquipoRepository eqRepo;

    public DocumentoLegalController(DocumentoLegalRepository repo, EquipoRepository eqRepo) {
        this.repo = repo;
        this.eqRepo = eqRepo;
    }

    @Data
    public static class DocDTO {
        private Long idEquipo;
        private String tipoPoliza;
        private String numeroPoliza;
        private LocalDate fechaVencimiento;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<DocumentoLegal> listar() {
        return repo.findAll();
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DocumentoLegal> crear(@RequestBody DocDTO d) {
        DocumentoLegal doc = new DocumentoLegal();
        doc.setEquipo(eqRepo.findById(d.getIdEquipo()).orElseThrow());
        doc.setTipoPoliza(d.getTipoPoliza());
        doc.setNumeroPoliza(d.getNumeroPoliza());
        doc.setFechaVencimiento(d.getFechaVencimiento());
        doc.setEstadoLegal("VIGENTE");
        return ResponseEntity.ok(repo.save(doc));
    }
}