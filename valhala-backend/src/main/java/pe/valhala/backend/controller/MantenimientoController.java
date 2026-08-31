package pe.valhala.backend.controller;

import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.MantenimientoTaller;
import pe.valhala.backend.repository.EquipoRepository;
import pe.valhala.backend.repository.MantenimientoTallerRepository;
import pe.valhala.backend.repository.UsuarioRepository;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/mantenimientos")
public class MantenimientoController {

    private final MantenimientoTallerRepository repo;
    private final EquipoRepository eqRepo;
    private final UsuarioRepository usrRepo;

    public MantenimientoController(MantenimientoTallerRepository repo, EquipoRepository eqRepo, UsuarioRepository usrRepo) {
        this.repo = repo;
        this.eqRepo = eqRepo;
        this.usrRepo = usrRepo;
    }

    @Data
    public static class ManDTO {
        private Long idEquipo;
        private String tipoMantenimiento;
        private BigDecimal horometroEjecucion;
        private BigDecimal costoReparacion;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<MantenimientoTaller> listar() {
        return repo.findAll();
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<MantenimientoTaller> crear(@RequestBody ManDTO d) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        MantenimientoTaller m = new MantenimientoTaller();
        m.setEquipo(eqRepo.findById(d.getIdEquipo()).orElseThrow());
        m.setUsuarioMecanico(usrRepo.findByEmail(email).orElseThrow());
        m.setTipoMantenimiento(d.getTipoMantenimiento());
        m.setHorometroEjecucion(d.getHorometroEjecucion());
        m.setCostoReparacion(d.getCostoReparacion());
        return ResponseEntity.ok(repo.save(m));
    }
}