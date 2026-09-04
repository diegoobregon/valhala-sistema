package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Contrato;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import pe.valhala.backend.repository.ContratoRepository;
import pe.valhala.backend.repository.EmpresaRepository;
import pe.valhala.backend.repository.EquipoRepository;
import pe.valhala.backend.repository.ItemContratoRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
@RestController
@RequestMapping("/api/v1/contratos")
public class ContratoController {
    private final ContratoRepository repo;
    private final ClienteCorporativoRepository cliRepo;
    private final UsuarioRepository usrRepo;
    private final EquipoRepository eqRepo;
    private final ItemContratoRepository itemRepo;
    private final EmpresaRepository empRepo;
    public ContratoController(ContratoRepository repo, ClienteCorporativoRepository cliRepo, UsuarioRepository usrRepo, EquipoRepository eqRepo, ItemContratoRepository itemRepo, EmpresaRepository empRepo) {
        this.repo = repo; this.cliRepo = cliRepo; this.usrRepo = usrRepo; this.eqRepo = eqRepo; this.itemRepo = itemRepo; this.empRepo = empRepo;
    }
    @Data public static class ItemDTO { private Long idEquipo; private BigDecimal tarifaPorHora; private BigDecimal horasMinimas; private BigDecimal costoFlete; }
    @Data public static class ContratoDTO { private Integer idCliente; private LocalDate fechaInicio; private LocalDate fechaFin; private List<ItemDTO> items; }
    private Integer empresaActual() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return usrRepo.findByEmail(email).map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
    }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<Contrato> listar() {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) return repo.findByIdEmpresa(idEmpresa);
        return repo.findAll();
    }
    @PostMapping @PreAuthorize("hasRole('ADMIN')") @Transactional
    public ResponseEntity<Contrato> crear(@RequestBody ContratoDTO d) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Contrato c = new Contrato();
        c.setCliente(cliRepo.findById(d.getIdCliente()).orElseThrow());
        c.setUsuarioCreador(usrRepo.findByEmail(email).orElseThrow());
        c.setFechaEmision(LocalDate.now());
        c.setFechaInicio(d.getFechaInicio());
        c.setFechaFin(d.getFechaFin());
        c.setEstadoContrato("ACTIVO");
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) c.setEmpresa(empRepo.findById(idEmpresa).orElse(null));
        Contrato guardado = repo.save(c);
        if (d.getItems() != null) {
            for (ItemDTO it : d.getItems()) {
                ItemContrato ic = new ItemContrato();
                ic.setContrato(guardado);
                ic.setEquipo(eqRepo.findById(it.getIdEquipo()).orElseThrow());
                ic.setTarifaPorHora(it.getTarifaPorHora() != null ? it.getTarifaPorHora() : BigDecimal.ZERO);
                ic.setHorasMinimasGarantizadas(it.getHorasMinimas() != null ? it.getHorasMinimas() : BigDecimal.ZERO);
                ic.setCostoFlete(it.getCostoFlete() != null ? it.getCostoFlete() : BigDecimal.ZERO);
                itemRepo.save(ic);
            }
        }
        return ResponseEntity.ok(guardado);
    }
}