package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Equipo;
import pe.valhala.backend.repository.CategoriaLineaAmarrillaRepository;
import pe.valhala.backend.repository.EmpresaRepository;
import pe.valhala.backend.repository.EquipoRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.math.BigDecimal;
import java.util.List;
@RestController
@RequestMapping("/api/v1/equipos")
public class EquipoController {
    private final EquipoRepository equipoRepo;
    private final CategoriaLineaAmarrillaRepository catRepo;
    private final UsuarioRepository usrRepo;
    private final EmpresaRepository empRepo;
    public EquipoController(EquipoRepository equipoRepo, CategoriaLineaAmarrillaRepository catRepo, UsuarioRepository usrRepo, EmpresaRepository empRepo) {
        this.equipoRepo = equipoRepo; this.catRepo = catRepo; this.usrRepo = usrRepo; this.empRepo = empRepo;
    }
    @Data public static class EquipoDTO {
        private Integer idCategoria; private String codigoPatrimonial; private String marca;
        private String modelo; private Integer anioFabricacion; private BigDecimal horometroAcumulado;
    }
    private Integer empresaActual() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return usrRepo.findByEmail(email).map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
    }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<Equipo> listar() {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) return equipoRepo.findByIdEmpresa(idEmpresa);
        return equipoRepo.findAll();
    }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Equipo> crear(@RequestBody EquipoDTO dto) {
        Equipo e = new Equipo(); aplicar(e, dto);
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) e.setEmpresa(empRepo.findById(idEmpresa).orElse(null));
        return ResponseEntity.ok(equipoRepo.save(e));
    }
    @PutMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Equipo> actualizar(@PathVariable Long id, @RequestBody EquipoDTO dto) {
        Equipo e = equipoRepo.findById(id).orElseThrow(); aplicar(e, dto);
        return ResponseEntity.ok(equipoRepo.save(e));
    }
    @DeleteMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) { equipoRepo.deleteById(id); return ResponseEntity.ok().build(); }
    private void aplicar(Equipo e, EquipoDTO dto) {
        e.setCategoria(catRepo.findById(dto.getIdCategoria()).orElseThrow());
        e.setCodigoPatrimonial(dto.getCodigoPatrimonial()); e.setMarca(dto.getMarca()); e.setModelo(dto.getModelo());
        e.setAnioFabricacion(dto.getAnioFabricacion()); e.setHorometroAcumulado(dto.getHorometroAcumulado());
    }
}