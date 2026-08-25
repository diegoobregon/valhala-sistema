package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.ReservaRequest;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.repository.ReservaGanttRepository;
import pe.valhala.backend.service.ReservaService;
import java.util.List;
@RestController @RequestMapping("/api/v1/reservas")
public class ReservaController {
    private final ReservaService service; private final ReservaGanttRepository repo;
    public ReservaController(ReservaService service, ReservaGanttRepository repo) { this.service = service; this.repo = repo; }
    @PostMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public ResponseEntity<ReservaGantt> crear(@Valid @RequestBody ReservaRequest req) { return ResponseEntity.ok(service.crear(req)); }
    @GetMapping("/gantt") @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<ReservaGantt> gantt() { return service.listarGantt(); }
    @DeleteMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> anular(@PathVariable Integer id) {
        ReservaGantt r = repo.findById(id).orElseThrow(); r.setEstadoReserva("ANULADA"); repo.save(r);
        return ResponseEntity.ok().build();
    }
}